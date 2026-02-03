# ---------------------------
# DB SUBNET GROUP
# ---------------------------
resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "photoshare-db-group"
  description = "DB Subnet Group for PhotoShare"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "photoshare-db-group"
  }
}

# ---------------------------
# DATABASE SECURITY GROUP
# ---------------------------
resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Security group for PhotoShare RDS database"
  vpc_id      = var.vpc_id

  ingress {
    description = "MySQL from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-sg"
  }
}

# ---------------------------
# RDS MYSQL INSTANCE
# ---------------------------
resource "aws_db_instance" "mysql" {
  identifier = "photoshare-db"

  engine         = "mysql"
  engine_version = "8.4"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = "photoshare"
  username = var.db_username
  password = var.db_password

  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  publicly_accessible = false
  multi_az            = false

  backup_retention_period = 0

  skip_final_snapshot = true

  tags = {
    Name = "photoshare-db"
  }
}
