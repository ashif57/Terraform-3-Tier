output "db_endpoint" {
  value = aws_db_instance.mysql.endpoint
}

output "db_sg_id" {
  value = aws_security_group.db_sg.id
}
output "vpc_id" {
  value = aws_vpc.photoshare.id
}

output "public_subnets" {
  value = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]
}

output "private_subnets" {
  value = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]
}
