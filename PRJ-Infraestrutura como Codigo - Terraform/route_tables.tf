# Criação das Rotas e suas Associações

# Esta sendo configurado uma rota para permitir o tráfego para a Internet.
# O valor "0.0.0.0/0" é um bloco CIDR padrão que representa toda a Internet.
# Desta forma qualquer tráfego que não tenha uma correspondência específica para outras rotas será direcionado para a Internet.

# gateway_id = aws_internet_gateway.santander-coders.id -> Especifica o ID do gateway de Internet utilizado para enviar o tráfego 
# para a Internet.

#  nat_gateway_id = aws_nat_gateway.santander_coders_vpc[count.index].id -> Determina o ID do NAT Gateway para o qual o tráfego 
# será enviado. O uso do NAT Gateway foi utilizado para permitir que as instâncias em subnets privadas acessem a Internet sem expor
# diretamente as instâncias à Internet.Oferecendo desta forma uma camada de segurança.


# Criação da tabela de rotas para uma sub-rede pública(Consiste em permitir tráfego para a Internet através de um Internet Gateway)
resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.santander-coders-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.santander-coders-igw.id
  }
  tags = {
    Name        = "${var.environment}-route_table_public"
    Environment = var.environment
    Managed_by  = "terraform"
  }
}

# Criação da tabela de rotas para subnets privadas acessar a Internet por nat(Permirir que as instâncias dentro de sunets
# privadas acessem a Internet de forma indireta através de um NAT Gateway (Network Address Translation Gateway), em vez de 
# um Internet Gateway.
resource "aws_route_table" "route_table_privada" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.santander-coders-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway[count.index].id
  }
  tags = {
    Name        = "${var.environment}-route_table_privada-${count.index + 1}"
    Environment = var.environment
    Managed_by  = "terraform"
  }
}

#Criação da Associação da Tabela de Rotas  com a subnet publica(A tabela de rotas contém as regras de roteamento, e a associação conecta essas regras 
# a uma subnet publica)
resource "aws_route_table_association" "association-route_table_publica" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.subnet_public[count.index].id
  route_table_id = aws_route_table.route_table_public.id
}

#Criação da Associação da Tabela de Rotas com a subnet privada(A tabela de rotas contém as regras de roteamento, e a associação conecta essas regras 
# a uma subnet privada-app)
resource "aws_route_table_association" "association-route_table_app" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.private_app[count.index].id
  route_table_id = aws_route_table.route_table_privada[count.index].id
}

#Criação da Associação da Tabela de Rotas com a subnet santander-coders-db(A tabela de rotas contém as regras de roteamento, e a associação conecta essas regras 
# a uma subnet santander-coders-db)
resource "aws_route_table_association" "association-route_table_db" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.subnet-santander-coders-privada-db[count.index].id
  route_table_id = aws_route_table.route_table_privada[count.index].id
}