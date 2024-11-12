# Vpc
resource "aws_vpc" "santander_coders_vpc" {
  cidr_block       = var.cidrvpc

  tags = {
    vpc = "santander-coder"
    name = "santander_coders_vpc"
  }
}

# Subnet Publica

resource "aws_subnet" "subnet-publica-a" {
  vpc_id     = aws_vpc.santander_coders_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "a"

  tags = {
    Name = "subnet-publica-a"
  }
  depends_on = [aws_vpc.santander_coders_vpc]
}

resource "aws_subnet" "subnet-publica-b" {
  vpc_id     = aws_vpc.santander_coders_vpc.id
  cidr_block = "10.0.3.0/24"
    availability_zone = "b"

  tags = {
    Name = "subnet-publica-b"
  }
  depends_on = [aws_vpc.santander_coders_vpc]
}

resource "aws_subnet" "subnet-publica-c" {
  vpc_id     = aws_vpc.santander_coders_vpc.id
  cidr_block = "10.0.4.0/24"
    availability_zone = "c"

  tags = {
    Name = "subnet-publica-c"
  }
  depends_on = [aws_vpc.santander_coders_vpc]
}

# Subnet Privada App

resource "aws_subnet" "subnet-app-a" {
  vpc_id     = aws_vpc.santander_coders_vpc.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "a"

  tags = {
    Name = "subnet-app-a"
  }
  depends_on = [aws_vpc.santander_coders_vpc]
}

resource "aws_subnet" "subnet-app-b" {
  vpc_id     = aws_vpc.santander_coders_vpc.id
  cidr_block = "10.0.6.0/24"
    availability_zone = "b"

  tags = {
    Name = "subnet-app-b"
  }
  depends_on = [aws_vpc.santander_coders_vpc]
}

resource "aws_subnet" "subnet-app-c" {
  vpc_id     = aws_vpc.santander_coders_vpc.id
  cidr_block = "10.0.7.0/24"
    availability_zone = "c"

  tags = {
    Name = "subnet-app-c"
  }
  depends_on = [aws_vpc.santander_coders_vpc]
}


# Subnet Privada SGBD - Sistema Gerenciador de Banco de Dados RDS

resource "aws_subnet" "subnet-bd-a" {
  vpc_id     = aws_vpc.santander_coders_vpc.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "a"

  tags = {
    Name = "subnet-bd-a"
  }
  depends_on = [aws_vpc.santander_coders_vpc]
}

resource "aws_subnet" "subnet-bd-a" {
  vpc_id     = aws_vpc.santander_coders_vpc.id
  cidr_block = "10.0.6.0/24"
    availability_zone = "b"

  tags = {
    Name = "subnet-bd-a"
  }
  depends_on = [aws_vpc.santander_coders_vpc]
}

resource "aws_subnet" "subnet-bd-c" {
  vpc_id     = aws_vpc.santander_coders_vpc.id
  cidr_block = "10.0.7.0/24"
    availability_zone = "c"

  tags = {
    Name = "subnet-bd-c"
  }
  depends_on = [aws_vpc.santander_coders_vpc]
}

# Internet Gateway

resource "aws_internet_gateway" "igw-satander-coders" {
vpc_id = aws_vpc.santander_coders_vpc.id

tags = {
Name = "igw-santander-coders"
}
}

# Alocação de ip (Elastic IP)

resource "aws_eip" "nat_eip_a" {
depends_on = [aws_internet_gateway.igw-satander-coders]
}

resource "aws_eip" "nat_eip_b" {
depends_on = [aws_internet_gateway.igw-satander-coders]
}

resource "aws_eip" "nat_eip_c" {
depends_on = [aws_internet_gateway.igw-satander-coders]
}

# Nat Gateway

resource "aws_nat_gateway" "nat-publica-a" {
allocation_id = aws_eip.nat_eip_a
subnet_id = aws_subnet.subnet-publica-a.id
tags = {
Name = "nat-publica-a"
}
depends_on = [aws_internet_gateway.igw-satander-coders]
}
resource "aws_nat_gateway" "nat-publica-b" {
allocation_id = aws_eip.nat_eip_b
subnet_id = aws_subnet.subnet-publica-b.id

tags = {
Name = "nat-publica-b"
}
depends_on = [aws_internet_gateway.igw-satander-coders]
}

resource "aws_nat_gateway" "nat-publica-c" {
allocation_id = aws_eip._nat_eip_c
subnet_id = aws_subnet.subnet-publica-c.id
tags = {
Name = "nat-publica-c"
}
depends_on = [aws_internet_gateway.igw-satander-coders]
}


# Route Table - Banco de Dados

resource "aws_route_table" "banco_de_dados" {
vpc_id = aws_vpc.santander_coders_vpc.id
route {
cidr_block = "0.0.0.0/16"
gateway_id = "local"
}
}

# Associação da Rota para Banco de Dados

resource "aws_route_table_association" "associacao_subnet_bd_a" {
subnet_id = aws_subnet.ubnet-bd-a.id
route_table_id = aws_route_table.banco_de_dados.id
}

resource "aws_route_table_association" "associacao_subnet_bd_b" {
subnet_id = aws_subnet.ubnet-bd-b.id
route_table_id = aws_route_table.banco_de_dados.id
}

resource "aws_route_table_association" "associacao_subnet_bd_c" {
subnet_id = aws_subnet.ubnet-bd-c.id
route_table_id = aws_route_table.banco_de_dados.id
}

# Route Table Privada - Banco de Dados.

resource "aws_route_table" "route_table_bd" {
vpc_id = aws_vpc.santander_coders_vpc.id
route {
cidr_block = "0.0.0.0/16"
nat_gateway_id = "local"
}
}

# Associação Rota

resource "aws_route_table_association" "route_table_app_a" {
subnet_id = aws_subnet.subnet-privada-app-a
route_table_id = aws_route_table.route_table_bd
}

resource "aws_route_table_association" "route_table_appb" {
subnet_id = aws_subnet.subnet-privada-app-b
route_table_id = aws_route_table.route_table_bd
}

resource "aws_route_table_association" "route_table_app_c" {
subnet_id = aws_subnet.subnet-privada-app-c
route_table_id = aws_route_table.route_table_bd
}

# Route Table -App(Aplicação)

resource "aws_route_table" "route-table-app-a" {
vpc_id = aws_vpc.santander_coders_vpc.id
route {
cidr_block = "0.0.0.0/16"
gateway_id = "local"
}
      route{
        cidr_block = "0.0.0.0/16"
        nat_gateway_id =  aws_nat_gateway.nat-publica-a.id

}
}

resource "aws_route_table" "route-table-app-a" {
vpc_id = aws_vpc.santander_coders_vpc.id
route {
cidr_block = "0.0.0.0/16"
gateway_id = "local"
}
      route{
        cidr_block = "0.0.0.0/16"
        nat_gateway_id =  aws_nat_gateway.nat-publica-a.id

}
}

resource "aws_route_table" "route-table-app-b" {
vpc_id = aws_vpc.santander_coders_vpc.id
route {
cidr_block = "0.0.0.0/16"
gateway_id = "local"
}
      route{
        cidr_block = "0.0.0.0/16"
        nat_gateway_id =  aws_nat_gateway.nat-publica-b.id

}
}

resource "aws_route_table" "route-table-app-c" {
vpc_id = aws_vpc.santander_coders_vpc.id
route {
cidr_block = "0.0.0.0/16"
gateway_id = "local"
}
      route{
        cidr_block = "0.0.0.0/16"
        nat_gateway_id =  aws_nat_gateway.nat-publica-c.id

}
}

# Associação Rota para a App 

resource "aws_route_table_association" "associacao_app_privada_a" {
subnet_id = aws_subnet.subnet-app-a.id
route_table_id = aws_route_table.route-table-app-c.id
}

resource "aws_route_table_association" "associacao_app_privada_b" {
subnet_id = aws_subnet.subnet-app-b.id
route_table_id = aws_route_table.rroute-table-app-b.id
}

resource "aws_route_table_association" "associacao_app_privada_c" {
subnet_id = aws_subnet.subnet-app-c.id
route_table_id = aws_route_table.route-table-app-c.id
}



