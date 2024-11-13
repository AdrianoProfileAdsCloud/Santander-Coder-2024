# Exposição de valores(Output)
# Outputs são usados para expor valores de recursos ou informações para outros módulos, para exibição no terminal ou para usar
# em outra parte do código ou automação. 

# aws_instance.machine_ec2- > Recurso do Terraform que define as instâncias EC2 criadas na sua configuração. O recurso é chamado 
# de machine_ec2, e pode ser definido para criar uma ou mais instâncias EC2, dependendo da configuração.

# Output para exibir o ID da VPC.
output "vpc_id" {
  description = "O ID do VPC"
  value       = aws_vpc.santander-coders-vpc.id
}


# Output que exibi o CIDR block da VPC criada
output "vpc_cidr" {
  description = "O CIDR bloco do VPC"
  value       = aws_vpc.santander-coders-vpc.cidr_block
}

# Output para exibi uma lista de IDs de subnets públicas dentro de uma VPC
output "ids_subnet_publicas" {
  description = "Listagem dos IDs das subnets publicas"
  value       = aws_subnet.subnet_public[*].id
}

# Output que exibe uma lista de IDs das subnets privadas destinadas a aplicações dentro da VPC
output "ids_subnets_privadas_app" {
  description = "Listagem dos IDs das subnets privadas de aplicações"
  value       = aws_subnet.private_app[*].id
}

# Output que exibe uma lista de IDs das subnets privadas destinadas ao banco de dados na VPC. 
output "private_db_subnet_ids" {
  description = "Listagem dos IDs da subnet privada de Banco de Dados"
  value       = aws_subnet.subnet-santander-coders-privada-db[*].id
}

# Output que exibe uma lista de IDs de NAT Gateways
output "nat_gateway_ids" {
  description = "Listagem dos IDs do NAT Gateway"
  value       = aws_nat_gateway.nat-gateway[*].id
}

# Output que expõe o nome do bucket do S3 criado no recurso santander-coders-bucket
output "bucket" {
  description = "Bucket do S3"
  value       = aws_s3_bucket.santander-coders-bucket
}

# Output que exibe uma lista de IDs de instâncias EC2 criadas a partir do recurso aws_instance.machine_ec2
output "ec2_ids" {
  description = "Lista de máquinas EC2"
  value       = aws_instance.machine_ec2[*].id
}

# Output que retorna a lista de subnets associadas ao grupo de subnets do banco de dados RDS
output "db_subnet_group_subnets" {
  description = "Lista de grupo de subnets para o banco de dados RDS"
  value       = aws_db_subnet_group.santander-coders-db-group.subnet_ids
}

# Output que retorna o nome de domínio da distribuição CloudFront associada ao Load Balancer
output "load_balancer_distribution_domain_name" {
  description = "CloudFront de Distribuição do Load Balancer"
  value       = aws_cloudfront_distribution.load_balancer_distribution.domain_name
}

# Output que retorna o nome de domínio da distribuição CloudFront associada ao bucket S3
output "s3_distribution_domain_name" {
  description = "CloudFront de Distribuição do S3"
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
}