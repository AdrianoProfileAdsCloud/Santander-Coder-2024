# Criação da Politica para o Bucket(S3)


# locals -> Usado para definir variáveis locais que podem ser reutilizadas dentro do código Terraform.
# Obs: Essas variáveis não são expostas externamente, mas servem para manter o código mais organizado e reutilizável.

# s3_policy-> Neste bloco, definindo uma variável local chamada s3_policy, que conterá em si a política de acesso

# jsonencode()-> É uma função usada para converter uma estrutura de dados (como um mapa ou lista no Terraform) 
# em uma string JSON. O que resultará em uma representação JSON válida da política.

# Statement-> Contém uma lista de declarações de política (neste caso, uma única declaração). Cada declaração especificará 
# um conjunto de permissões para um recurso, em formato de ação, principal e condição.

# Sid: "AllowCloudFrontServicePrincipal" -> identificador opcional para a declaração de política, uisado para fins de auditoria
# ou rastreamento. Aqui foi nomeado como "AllowCloudFrontServicePrincipal", indicando que a declaração concede permissões para o CloudFront.

# Effect: "Allow"-> Diz se a política deve permitir (Allow) ou negar (Deny) a ação. Neste caso, é Allow, permitindo o acesso.

# Principal -> Define o executor da ação especificada. Neste caso o principal e o cloudfront.amazonaws.com, desta forma 
# estamos permitindo que o serviço CloudFront tenha acesso ao conteúdo do bucket.

locals {
  s3_policy = jsonencode(
    {
      "Version" : "2008-10-17",
      "Id" : "PolicyForCloudFrontPrivateContent",
      "Statement" : [
        {
          "Sid" : "AllowCloudFrontServicePrincipal",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "cloudfront.amazonaws.com"
          },
          "Action" : "s3:GetObject",
          "Resource" : "${aws_s3_bucket.santander-coders-bucket.arn}/*",
          "Condition" : {
            "StringEquals" : {
              "AWS:SourceArn" : aws_cloudfront_distribution.s3_distribution.arn
            }
          }
        }
      ]
    }
  )
}