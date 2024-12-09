variable "bucket_name" {
  type        = string
  description = "Nome do bucket na aws"
  default     = "prj-devops-2024-adriano"
}

variable "environment" {
  description = "Define o nome do ambiente, neste caso setado como default, mas poderiamos ter outros"
  default     = "dev"
}

variable "endereco_de_email" {
  description = "Envia um email disparado pela função lambida informando o status da persistência no banco de dados"
  default = "adrianoprogm@hotmail.com"
  
}
