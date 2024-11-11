resource "aws_vpc" "santander_coders_vpc" {
  cidr_block       = var.cidrvpc

  tags = {
    vpc = "santander-coder"
    name = "prj-terraform"


  }


# # Subnet Publica

resource "aws_subnet" "subnet-publica-a" {
  vpc_id     = aws_vpc.santander_coders_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "a"

  tags = {
    Name = "subnet-publica-a"
  }
  depends_on = {aws_vpc.santander_coders_vpc}
}

resource "aws_subnet" "subnet-publica-b" {
  vpc_id     = aws_vpc.santander_coders_vpc.id
  cidr_block = "10.0.3.0/24"
    availability_zone = "b"

  tags = {
    Name = "subnet-publica-b"
  }
  depends_on = {aws_vpc.santander_coders_vpc}
}

resource "aws_subnet" "subnet-publica-c" {
  vpc_id     = aws_vpc.santander_coders_vpc.id
  cidr_block = "10.0.4.0/24"
    availability_zone = "c"

  tags = {
    Name = "subnet-publica-c"
  }
  depends_on = {aws_vpc.santander_coders_vpc}
}

# Internet Gateway

resource "aws_internet_gateway" "gw-sandanser-coders" {
  vpc_id = aws_vpc.santander_coders_vpc.id

  tags = {
    Name = "gw-sandanser-coders"
  }

# Subnet Privada App

resource "aws_subnet" "subnet-privada-app-a" {
  vpc_id     = aws_vpc.santander_coders_vpc.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "a"

  tags = {
    Name = "subnet-privada-app-a"
  }
  depends_on = {aws_vpc.santander_coders_vpc}
}

resource "aws_subnet" "subnet-privada-app-b" {
  vpc_id     = aws_vpc.santander_coders_vpc.id
  cidr_block = "10.0.6.0/24"
    availability_zone = "b"

  tags = {
    Name = "subnet-privada-app-b"
  }
  depends_on = {aws_vpc.santander_coders_vpc}
}

resource "aws_subnet" "subnet-privada-app-c" {
  vpc_id     = aws_vpc.santander_coders_vpc.id
  cidr_block = "10.0.7.0/24"
    availability_zone = "c"

  tags = {
    Name = "subnet-privada-app-c"
  }
  depends_on = {aws_vpc.santander_coders_vpc}
}

# Nat Gateway
  
  resource "aws_nat_gateway" "nat-publica-a" {
  #allocation_id = aws_eip.example.id
  subnet_id     = aws_subnet.subnet-publica-a.id
    Name = "NAT-A"
  }
  depends_on = [aws_internet_gateway.example]
}
resource "aws_nat_gateway" "nat-publica-b" {
  #allocation_id = aws_eip.example.id
  subnet_id     = aws_subnet.subnet-publica-b.id

  tags = {
    Name = "NAT-B"
  }
  depends_on = [aws_internet_gateway.example]
}
resource "aws_nat_gateway" "nat-publica-c" {
  #allocation_id = aws_eip.example.id
  subnet_id     = aws_subnet.subnet-publica-c.id
  tags = {
    Name = "NAT-C"
  }
  depends_on = [aws_internet_gateway.gw-sandanser-coders]
}
}