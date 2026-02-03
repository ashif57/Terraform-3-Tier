# ---------------------------
# ALB SECURITY GROUP
# ---------------------------
resource "aws_security_group" "alb_sg" {
  name        = "photoshare-sg"
  description = "Security group for PhotoShare ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "photoshare-sg"
  }
}

# ---------------------------
# APPLICATION LOAD BALANCER
# ---------------------------
resource "aws_lb" "alb" {
  name               = "photoshare-alb"
  load_balancer_type = "application"
  internal           = false
  ip_address_type    = "ipv4"

  security_groups = [aws_security_group.alb_sg.id]
  subnets         = var.public_subnet_ids

  tags = {
    Name = "photoshare-alb"
  }
}

# ---------------------------
# TARGET GROUP
# ---------------------------
resource "aws_lb_target_group" "tg" {
  name     = "photoshare-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  target_type = "instance"

  health_check {
    path = "/"
    protocol = "HTTP"
  }

  tags = {
    Name = "photoshare-tg"
  }
}

# ---------------------------
# LISTENER (PORT 80)
# ---------------------------
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
