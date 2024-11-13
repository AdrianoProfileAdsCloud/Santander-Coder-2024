# Criação do Bucket S3

# policy = local.s3_policy -> Especifica a política de acesso que será aplicada ao bucket S3

resource "aws_s3_bucket" "santander-coders-bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "antander-coders-bucket-app"
    Environment = var.environment
  }
}

# Definido política de acesso para o bucket santander-coders-bucket

resource "aws_s3_bucket_policy" "santander-coders-bucket-police" {
  bucket = aws_s3_bucket.santander-coders-bucket.id
  policy = local.s3_policy
}