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

# Subnet Privada 

resource "aws_subnet" "subnet-privada-a" {
  vpc_id     = aws_vpc.santander_coders_vpc.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "a"

  tags = {
    Name = "subnet-privada-a"
  }
  depends_on = [aws_vpc.santander_coders_vpc]
}

resource "aws_subnet" "subnet-privada-b" {
  vpc_id     = aws_vpc.santander_coders_vpc.id
  cidr_block = "10.0.6.0/24"
    availability_zone = "b"

  tags = {
    Name = "subnet-privada-b"
  }
  depends_on = [aws_vpc.santander_coders_vpc]
}

resource "aws_subnet" "subnet-privada-c" {
  vpc_id     = aws_vpc.santander_coders_vpc.id
  cidr_block = "10.0.7.0/24"
    availability_zone = "c"

  tags = {
    Name = "subnet-privada-c"
  }
  depends_on = [aws_vpc.santander_coders_vpc]
}

