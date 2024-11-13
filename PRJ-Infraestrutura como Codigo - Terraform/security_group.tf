#Criação do Security Group(Controle de acesso às instâncias EC2 dentro da uma VPC)

# ingress -> Define as regras de entrada para o grupo de segurança.Elas
# controlam o tráfego que pode entrar nas instâncias associadas a esse grupo de segurança.Neste caso permitindo o
# tráfego de entrada para as portas especificadas abaixo.

# egress-> Controla o tráfego de saída de instâncias associadas a esse grupo de segurança.Elas permitem 
# ou bloqueiam o tráfego que sai das instâncias associadas a este grupo de segurança.

# from_port = 0 e to_port = 0 -> Indicam que a regra se aplica a todas as portas, não está restringindo o tráfego 
# de saída a nenhuma porta específica, qualquer tráfego de saída (em qualquer porta) será permitido.
# protocol = "-1" -> Indica que a regra se aplica a todos os protocolos

# Criação do Security Group para Ec2
resource "aws_security_group" "ec2_security_group" {
  name        = "enable_ssh_http"
  description = "Habilitar SSH e HTTP o que significa que esse grupo de seguranca permitira o trafego nas portas correspondentes"
  vpc_id      = aws_vpc.santander-coders-vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.santander-coders-vpc.cidr_block]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.santander-coders-vpc.cidr_block]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.santander-coders-vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-ec2-security-group"
  }
}

# Criação do Security Group para o Banco de Dados(Permite tráfego de entrada e saida para MySQL)
resource "aws_security_group" "bd-security-group" {
  name        = "bd-security-group"
  description = "Permite trafego de entrada e saida para MySQ"
  vpc_id      = aws_vpc.santander-coders-vpc.id

  tags = {
    Name = "bd-security-group"
  }
}

# Criação do Security Group para o Load Balancer (LB).
resource "aws_security_group" "lb-security-group" {
  name        = "lb-security-group"
  description = "O grupo de seguranca criado permitira trafego de entrada para o Load Balancer na porta especifica geralmente HTTP e HTTPS e de acordo com a descricao permitira todo trafego de saida."
  vpc_id      = aws_vpc.santander-coders-vpc.id

  tags = {
    Name = "lb-security-group"
  }
}

#Criação da Rule para o Banco de Dados(Configurada para permitir tráfego de entrada (ingress) na porta do MySQL (3306) e direciona ao grupo de segurança bd-security-group)
resource "aws_security_group_rule" "db-security-rule" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.bd-security-group.id
  cidr_blocks       = [aws_vpc.santander-coders-vpc.cidr_block]
}

# Criação de regra para permitir tráfego de entrada (ingress) na porta 80 (porta HTTP) de uma faixa de IPs específica da VPC santander-coders.
resource "aws_security_group_rule" "lb-security-rule-ingress-http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.lb-security-group.id
  cidr_blocks       = [aws_vpc.santander-coders-vpc.cidr_block]
}

# Criação de regra para permitir o tráfego HTTPS (porta 443) de entrada para um grupo de segurança associado ao Load Balancer 
# A regra esta configurada para permitir tráfego na porta 443 (usada para HTTPS) proveniente de endereços IP dentro de uma faixa CIDR
# específica da VPC santander-coders.
resource "aws_security_group_rule" "lb-security-rule-ingress-https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.lb-security-group.id
  cidr_blocks       = [aws_vpc.santander-coders-vpc.cidr_block]
}

# Criação da regra  para permitir tráfego de saída (egress) de um grupo de segurança associado ao Load Balancer, 
# permitindo tráfego para qualquer destino (na Internet ou fora da VPC).
resource "aws_security_group_rule" "lb-security-rule-egress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.lb-security-group.id
  cidr_blocks       = ["0.0.0.0/0"]
}