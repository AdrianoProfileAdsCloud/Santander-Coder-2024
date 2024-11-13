# Criação das Subnets

# O Count é uma meta-argumento que permite criar múltiplas instâncias de um recurso com base em um valor,
# neste caso o valor foi definido no arquivo variables.tf.
# onde var.availability_zones fará com que o Terraform crie uma sub-rede pública para cada zona 
# de disponibilidade fornecida na variável.

# cidr_block = cidrsubnet(var.vpc_cidr, 4, count.index)-> Define o bloco CIDR para a sub-rede. A função 
# cidrsubnet é usada para calcular sub-redes menores dentro do bloco CIDR principal da VPC.
# var.vpc_cidr -> Contém o bloco CIDR da VPC, de onde as sub-redes serão derivadas.
# 4: Este número indica quantos bits adicionais serão utilizados para definir o tamanho do bloco CIDR de cada sub-rede.
# Neste caso, ele está dividindo a VPC em 16 sub-redes (2^4 = 16 sub-redes).
# count.index: O count.index é o índice da iteração atual. O cidrsubnet vai gerar um bloco CIDR diferente para cada 
# sub-rede, baseado nesse índice. Por exemplo, a primeira sub-rede terá o índice 0, a segunda terá o índice 1, e assim por diante

# map_public_ip_on_launch = true -> As instâncias EC2 que forem lançadas nessa sub-rede terão automaticamente um endereço
# IP público atribuído a elas.

# Tier -> Indica que essas sub-redes são públicas.

# O grupo de sub-redes -> Necessário para que o banco de dados RDS funcione corretamente em uma VPC,
# pois ele define as sub-redes onde o RDS pode ser provisionado.

# subnet_ids = aws_subnet.subnet-santander-coders-privada-db[*].id -> Parâmetro que define as sub-redes que farão parte do grupo 
# de sub-redes.
# O valor aws_subnet.subnet-santander-coders-privada-db[*].id -> Faz referência ao ID das sub-redes criadas.
# aws_subnet.subnet-santander-coders-privada-db -> É o nome de um ou mais recursos de sub-rede definidos no Terraform. O código 
# está usando uma sintaxe de referência de lista ([*]) para obter os IDs de todas as sub-redes que são nomeadas com esse prefixo 
#(subnet-santander-coders-privada-db).
# id: Extrai o ID de cada sub-rede criada, o que é necessário para associá-las ao grupo de sub-redes do banco de dados RDS.
# O grupo de sub-redes precisa terá duas sub-redes em zonas de disponibilidade diferentes para garantir alta disponibilidade.

# Criação da Subnets Publicas
resource "aws_subnet" "subnet_public" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.santander-coders-vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, count.index)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-subnet-santander-coders-publica-${count.index + 1}"
    Environment = var.environment
    Tier        = "Publica"
    Managed_by  = "terraform"
  }
}

# Criação da Subnets Privadas para a aplicação
resource "aws_subnet" "private_app" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.santander-coders-vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, count.index + 4)
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name        = "${var.environment}-subnet-santander-coders-privada-${count.index + 1}"
    Environment = var.environment
    Tier        = "Privada App"
    Managed_by  = "terraform"
  }
}

# Criação da Subnets para o Bando de Dados
resource "aws_db_subnet_group" "santander-coders-db-group" {
  name        = "santander-coders-db"
  description = "Grupo de Subnet para o banco de dados RDS"
  subnet_ids  = aws_subnet.subnet-santander-coders-privada-db[*].id

  depends_on = [aws_subnet.subnet-santander-coders-privada-db]

  tags = {
    Name        = "${var.environment}-subnet-group-db"
    Environment = var.environment
    Managed_by  = "terraform"
  }
}

resource "aws_subnet" "subnet-santander-coders-privada-db" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.santander-coders-vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, count.index + 8)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.environment}-private-db-subnet-${count.index + 1}"
    Environment = var.environment
    Tier        = "private-db"
    Managed_by  = "terraform"
  }
}