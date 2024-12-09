import boto3
import os

s3_client = boto3.client("s3")
sns_client = boto3.client("sns")
sns_topic_arn = os.getenv("SNS_TOPIC_ARN")

def lambda_handler(event, context):
    for record in event["Records"]:
        bucket_name = record["s3"]["bucket"]["name"]
        file_key = record["s3"]["object"]["key"]
        
        # Obter informações detalhadas do arquivo
        response = s3_client.head_object(Bucket=bucket_name, Key=file_key)
        print(f"Informações do arquivo: {response}")

        try:
            # Baixar o arquivo do S3
            response = s3_client.get_object(Bucket=bucket_name, Key=file_key)
            content = response["Body"].read().decode("utf-8")
            line_count = len(content.splitlines())  # Contar as linhas do arquivo
            
            # Foi adicionado para facilitar a visualização das informações no CloudW Watch
            # Exibir o nome do arquivo e a quantidade de linhas
            print(f"Nome do arquivo: {file_key}")
            print(f"Quantidade de linhas: {line_count}")

            # Publicar mensagem no SNS
            message = f"Arquivo '{file_key}' processado com sucesso. Linhas: {line_count}."
            sns_client.publish(
                TopicArn=sns_topic_arn,
                Message=message,
                Subject="Processamento de Arquivo"
            )
        
        except Exception as e:
            # Em caso de erro, publica a mensagem de erro no SNS
            error_message = f"Erro ao processar o arquivo '{file_key}': {str(e)}"
            sns_client.publish(
                TopicArn=sns_topic_arn,
                Message=error_message,
                Subject="Erro no Processamento"
            )
            raise e
