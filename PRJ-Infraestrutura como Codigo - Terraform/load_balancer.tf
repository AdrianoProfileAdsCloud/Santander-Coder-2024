# Criação do Applicatgion Load Balancer(ALB)

# Criado para distribuir o tráfego de rede entre várias instâncias de back-end, garantindo escalabilidade, disponibilidade
# e confiabilidade.

# aws_lb_target_group -> O Target Group define um conjunto de destinos (instâncias EC2, containers, etc.) para os quais o 
# tráfego será direcionado e também configura a verificação de saúde dessas instâncias.

# health_check { ... } -> Deternina a política de verificação de saúde para os destinos no Target Group. Com isso garantimos que o ALB
# só envie tráfego para instâncias que estão saudáveis e respondendo corretamente.

# "aws_lb_listener"-> Este é o tipo de recurso que estamos criando, que é um Listener do Load Balancer. Ele permite configurar 
# as regras e ações para o tráfego recebido.

# load_balancer_arn = aws_lb.front_end.arn -> Este é o ARN (Amazon Resource Name) do Load Balancer com o qual o listener estará associado. 
# O aws_lb.front_end.arn faz referência ao ARN do Load Balancer previamente configurado (lb-front-end).
# Obs: O Load Balancer é o ponto de entrada para o tráfego de rede. Ele irá direcionar o tráfego para as instâncias EC2 ou outros 
# recursos dentro do target group especificado.

# default_action { ... } -> Determina o que o listener deve fazer com o tráfego recebido. O default_action é a ação padrão que será 
# tomada quando nenhuma outra regra específica corresponder ao tráfego.
# Neste caso, a ação padrão será de "forward" o tráfego para um Target Group específico.
# O parâmetro default_action define a maneira como o Load Balancer irá encaminhar o tráfego. No caso de um listener HTTP, a ação de 
# encaminhamento (forward) é a mais comum.

# type = "forward"-> O tipo "forward" indica que o tráfego será encaminhado para um Target Group.
# O que quer dizer que o Load Balancer irá encaminhar o tráfego para as instâncias EC2 ou outros destinos configurados no Target Group,
# que é o grupo de recursos que irá processar o tráfego.



# Criação LB 
resource "aws_lb" "lb-front-end" {
  name               = "lb-front-end"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-security-group.id]
  subnets            = aws_subnet.subnet_public[*].id

  enable_deletion_protection = false

  tags = {
    Name        = "lb-front-end"
    Environment = var.environment
  }
}

# Configurando Target Group no Application Load Balancer (ALB)
# Para gerenciar as instâncias que recebem o tráfego de rede do Load Balancer.
resource "aws_lb_target_group" "target-group-front-end" {
  name        = "front-end-target-group-${random_id.suffix.hex}"  
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.santander-coders-vpc.id
  target_type = "instance"

  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}

# Definindo como o Load Balancer deverá responder ao tráfego recebido em uma porta e protocolo específicos
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.lb-front-end.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group-front-end.arn
  }
}
resource "aws_lb_target_group_attachment" "front_end" {
  for_each         = { for idx, instance in aws_instance.machine_ec2 : idx => instance }
  target_group_arn = aws_lb_target_group.target-group-front-end.arn
  target_id        = each.value.id
  port             = 80
}

resource "random_id" "suffix" {
  byte_length = 4
}