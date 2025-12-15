#crear un Application Load Balancer (ALB) para el frontend

resource "aws_lb" "this" {
  name               = "frontend-alb-${var.environment}"
  load_balancer_type = "application"
  internal           = false #frente al internet (cloudfront)

  subnets         = var.public_subnets
  security_groups = [aws_security_group.alb.id] #se usa el security group creado mas adelante

  tags = {
    Environment = var.environment
  }
}

# se prepara el target group para el alb que apunte a las task del cluster ecs

resource "aws_lb_target_group" "frontend" {
  name     = "frontend-tg-${var.environment}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}

#security group para el alb que permita trafico http y https desde internet

resource "aws_security_group" "alb" {
  name   = "frontend-alb-sg-${var.environment}"
  vpc_id = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #salida libre
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg-${var.environment}"
  }
}

