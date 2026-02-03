variable "vpc_id" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "alb_sg_id" {
  type = string
}

variable "db_sg_id" {
  type = string
}

variable "instance_profile" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "key_name" {
  type = string
}
