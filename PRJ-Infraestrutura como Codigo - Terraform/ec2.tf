# Criação das Instancias

# ami = data.aws_ami.amazon_linux.id -> A variável amidefine o ID da AMI (Amazon Machine Image) a ser usada para a instância EC2.
# data.aws_ami.amazon_linux.id -> Gaz referência a um recurso data existente que recupera o ID da AMI para uma imagem específica do Amazon Linux. 
# que se encontra no arquivo main.tf

resource "aws_instance" "machine_ec2" {
  count                  = length(var.availability_zones)
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_app[count.index].id
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]

  tags = {
    Name        = "${var.environment}-machine-az-${element(var.availability_zones, count.index)}"
    Environment = var.environment
  }
}