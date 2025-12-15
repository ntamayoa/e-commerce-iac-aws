#Similar a ALB para frontend pero se usa detrás de un API Gateway VPC Link

resource "aws_lb" "this" {
  name               = "backend-alb-${var.environment}"
  load_balancer_type = "application"
  internal           = true #interno, detras del API Gateway VPC Link

  subnets         = var.private_subnets
  security_groups = [aws_security_group.alb.id]

  tags = {
    Name        = "backend-alb-${var.environment}"
    Environment = var.environment
  }
}


resource "aws_lb_target_group" "backend" {
  name     = "backend-tg-${var.environment}"
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
    target_group_arn = aws_lb_target_group.backend.arn
  }
}

#security group para el alb que permita trafico http desde el API Gateway VPC Link

resource "aws_security_group" "alb" {
  name   = "backend-alb-sg-${var.environment}"
  vpc_id = var.vpc_id

  ingress {
    description     = "From API Gateway VPC Link"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "backend-alb-sg-${var.environment}"
  }
}


