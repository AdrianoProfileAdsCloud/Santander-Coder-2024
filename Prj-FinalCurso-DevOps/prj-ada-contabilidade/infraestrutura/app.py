from generate_file import generate_random_file
from upload_s3 import upload_to_s3
import os
import boto3

# Configurações
BUCKET_NAME = os.getenv("BUCKET_NAME", "prj-devops-2024-adriano")

if __name__ == "__main__":
    # Gera o arquivo aleatório
    file_path, num_lines = generate_random_file()

    # Envia para o S3
    upload_to_s3(file_path, BUCKET_NAME)


# Inicializar o cliente SNS
sns = boto3.client('sns')
SNS_TOPIC_ARN = "arn:aws:sns:us-east-1:209945328913:prj_devops_2024_sns"

def send_notification(subject, message):
    sns.publish(
        TopicArn=SNS_TOPIC_ARN,
        Subject=subject,
        Message=message
    )

# Exemplo de uso no lambda_handler
send_notification(
    "Processamento Concluído",
    f"O arquivo {key} foi processado com sucesso e contém {num_lines} linhas."
)