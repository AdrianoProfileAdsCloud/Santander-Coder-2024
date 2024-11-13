
# Criação da Vpc.
# Usada para habilitar nomes de host DNS para instâncias em uma VPC.
# Ativa ou não o suporte DNS para o VPC.

# Tag Managed_by é apenas informativa e define quem gerencia o recurso. Aqui, está configurado como
# "terraform", indicando que o Terraform é o responsável por criar e gerenciar a VPC.

resource "aws_vpc" "santander-coders-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
    Managed_by  = "terraform"
  }
}

resource "aws_internet_gateway" "santander-coders-igw" {
  vpc_id = aws_vpc.santander-coders-vpc.id

  tags = {
    Name        = "${var.environment}-santander-coders-igw"
    Environment = var.environment
    Managed_by  = "terraform"
  }
}


