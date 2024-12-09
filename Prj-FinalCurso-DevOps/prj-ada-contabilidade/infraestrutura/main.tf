terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.79.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      projeto = "SantanderCoders 2024 - Trilha DevOps"
      dono    = "Adriano Aparecido da Silva"
    }
  }
}


# S3 Bucket
resource "aws_s3_bucket" "prj_devops_2024_s3" {
  bucket = var.bucket_name

  tags = {
    Name        = "prj_devops_2024"
    Environment = var.environment
  }
}

# SNS Topic
resource "aws_sns_topic" "email_notifications" {
  name = "prj-devops-2024-sns"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.email_notifications.arn
  protocol  = "email"
  endpoint  = var.endereco_de_email
}

# SQS Standard Queue
resource "aws_sqs_queue" "prj_devops_2024_sqs_standard" {
  name                      = "prj-devops-2024-sqs-standard"
  delay_seconds             = 0
  message_retention_seconds = 345600

  tags = {
    Name        = "prj_devops_2024"
    Environment = var.environment
  }
}

# SQS Queue Policy for S3 to send messages
resource "aws_sqs_queue_policy" "s3_to_sqs_policy" {
  queue_url = aws_sqs_queue.prj_devops_2024_sqs_standard.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "s3.amazonaws.com"
        },
        Action    = "sqs:SendMessage",
        Resource  = aws_sqs_queue.prj_devops_2024_sqs_standard.arn,
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_s3_bucket.prj_devops_2024_s3.arn
          }
        }
      }
    ]
  })
}

# IAM Role for Lambdas
resource "aws_iam_role" "lambda_role" {
  name = "prj-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# A declaração data "aws_region" "current" {} e data "aws_caller_identity" "current" {} foi necessárias para poder
# construir dinamicamente o ARN de recursos relacionados ao CloudWatch Logs para a  conta e região.
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}


# Criando a Política IAM que permite à função Lambda criar grupos de logs, fluxos de logs e enviar eventos de logs para o CloudWatch Logs.
resource "aws_iam_policy" "lambda_policy" {
  name = "prj-lambda-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = ["s3:GetObject"],
        Effect = "Allow",
        Resource = "${aws_s3_bucket.prj_devops_2024_s3.arn}/*"
      },
      {
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ],
        Effect = "Allow",
        Resource = aws_sqs_queue.prj_devops_2024_sqs_standard.arn
      },
      {
        Action = "sns:Publish",
        Effect = "Allow",
        Resource = aws_sns_topic.email_notifications.arn
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect = "Allow",
        Resource = "arn:aws:logs:*:*:*"  # Permite acesso ao CloudWatch Logs para todas as regiões e contas
      },
      {
        # Permissões específicas para a função Lambda gravar logs no CloudWatch
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect = "Allow",
        Resource = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*"
      }
    ]
  })
}

# Anexa a política criada à role da função Lambda.
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# Lambda to Process S3 Files
data "archive_file" "lambda_package" {
  type        = "zip"
  source_file = "process_s3_file.py"
  output_path = "lambda_package.zip"
}

resource "aws_lambda_function" "process_s3_files" {
  function_name = "process_s3_files"
  runtime       = "python3.9"
  handler       = "process_s3_file.lambda_handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = data.archive_file.lambda_package.output_path

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.email_notifications.arn
    }
  }
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.process_s3_files.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.prj_devops_2024_s3.arn
}

resource "aws_s3_bucket_notification" "bucket_notifications" {
  bucket = aws_s3_bucket.prj_devops_2024_s3.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.process_s3_files.arn
    events              = ["s3:ObjectCreated:*"]
  }
}
