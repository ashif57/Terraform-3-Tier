resource "aws_security_group" "web_sg" {
  name        = "photoshare-web-sg"
  description = "Security group for Web Server"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
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
    Name = "photoshare-web-sg"
  }
}
resource "aws_security_group_rule" "db_from_ec2" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = var.db_sg_id
  source_security_group_id = aws_security_group.web_sg.id
}
resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  key_name = var.key_name

  iam_instance_profile = var.instance_profile

  associate_public_ip_address = true

  user_data = <<EOF
#!/bin/bash
dnf install -y docker git
systemctl enable --now docker
usermod -aG docker ec2-user

curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

cat <<EOC > /home/ec2-user/.env
S3_BUCKET=${var.bucket_name}
AWS_SECRET_NAME=photoshare/db/credentials
EOC

# paste your docker-compose content below
cat <<EOC > /home/ec2-user/docker-compose.yml
${file("${path.module}/docker-compose.yml")}
EOC

cd /home/ec2-user
docker-compose up -d
EOF

  tags = {
    Name = "photoshare-web"
  }
}
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}
resource "aws_lb_target_group_attachment" "attach" {
  target_group_arn = var.target_group_arn
  target_id        = aws_instance.web.id
  port             = 80
}
