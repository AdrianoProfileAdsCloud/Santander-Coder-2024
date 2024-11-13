# Criação Elastic IP.

# domain = "vpc" -> Define o contexto do EIP. Ao definir domain = "vpc", estou indicando que o EIP será utilizado dentro de uma 
# VPC (Virtual Private Cloud), ao invés de ser um IP público global.
# "vpc"-> Especifica que o Elastic IP será alocado para uso dentro de uma VPC, se faz necessário já que estará a recursos dentro de uma VPC(NAT Gateways)

# Criação recursos de Elastic IP (EIP) dentro da VPC para serem utilização com NAT Gateways
resource "aws_eip" "nat-eip" {
  count  = length(var.availability_zones)
  domain = "vpc"

  tags = {
    Name        = "${var.environment}-nat-eip-${count.index + 1}"
    Environment = var.environment
    Managed_by  = "terraform"
  }
}

resource "aws_nat_gateway" "nat-gateway" {
  count         = length(var.availability_zones)
  allocation_id = aws_eip.nat-eip[count.index].id
  subnet_id     = aws_subnet.subnet_public[count.index].id

  depends_on = [aws_internet_gateway.santander-coders-igw]

  tags = {
    Name        = "${var.environment}-nat-${count.index + 1}"
    Environment = var.environment
    Managed_by  = "terraform"
  }
}