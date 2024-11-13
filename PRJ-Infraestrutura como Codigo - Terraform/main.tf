# Arquivo Principal

# provider "aws" { ... } -> Onde você se faz adefinição qual provedor (no caso, a AWS) o Terraform deve usar para criar
# e gerenciar os recursos.

# data source aws_ami ->  Busca informações sobre uma Amazon Machine Image (AMI) específica, que será utilizada, por exemplo,
# para lançar instâncias EC2 com base nessa imagem
# data-> O Terraform possui dois tipos principais de blocos: resource e data.
# Onde resource é usado para criar e gerenciar recursos na AWS (ou outro provedor).
# E data é usado para consultar informações de recursos existentes, sem fazer alterações neles.

# filter { ... } -> Usado para refinar a busca das AMIs, permitindo definir condições específicas para as imagens a ser recuperada.
# Neste caso foi configurado com um filtro de nome.

# amzn2-ami-hvm-*-x86_64-gp2 -> Este padrão corresponde ao nome das AMIs do Amazon Linux 2.
# Onde amzn2-ami-hvm-> Indica que é uma AMI do Amazon Linux 2 com suporte para HVM (Hardware Virtual Machine).
# *-x86_64: O * -> É um caractere coringa que pode corresponder a qualquer versão, e x86_64 significa que é uma AMI de arquitetura de 64 bits.
# gp2-> Esse é o tipo de volume padrão de armazenamento do Amazon EC2, usando EBS (Elastic Block Store) no modo General Purpose SSD.


terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "<=5.75.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      projeto = "SantanderCoders 2024"
      dono    = "Adriano Aparecido da Silva"
    }
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}