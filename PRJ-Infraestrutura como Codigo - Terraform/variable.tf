
# Criando váriaveis que serão utilizadas
# para referenciar a variável em outras partes da configuração do Terraform.

# A tag Environment recebe o valor de var.ambiente, indicando o ambiente onde a VPC será criada.

variable "environment" {
  description = "Define o nome do ambiente, neste caso setado como default, mas poderiamos ter outros"
  default     = "dev"
}

variable "vpc_cidr" {
  description = "VPC CIDR bloco"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Lista de Zonas de Disponibilidades dentro da região US-EAST"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "bucket_name" {
  description = "Bucket S3 da Aplicação"
  type        = string
  default     = "satander-coders-bucket-public-s3"
}

variable "instance_type" {
  description = "Definição do Tipo de instância EC2"
  type        = string
  default     = "t2.micro"
}

variable "root_password" {
  description = "Define a senha do Usuário root para o RDS"
  type        = string
  default     = "Cod#ers2024"
}

variable "iops" {
  description = "IOPS for the RDS"
  type        = number
  default     = 3000
}

variable "allocated_storage" {
  description = "Espaço de armazenamento alocado para a base de dados do RDS (Relational Database Service) "
  type        = number
  default     = 400
}