terraform {
    required_version = ">= 1.0.0"    
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "<=5.75.0"
    }
  }
  backend "s3" {
    name = "value"
  }
  
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
    projeto = "SantanderCoders 2024"
    dono = "Adriano Aparecido da Silva"
  }
}

