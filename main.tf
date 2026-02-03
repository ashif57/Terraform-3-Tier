module "vpc" {
  source = "./modules/vpc"
}

module "secret-manager" {
  source = "./modules/secretms"
    db_username = "admin"
  db_password = "admin123"
  db_host     = module.rds.db_endpoint
  db_name     = "photoshare"
}

module "rds" {
  source = "./modules/rds"
 
    vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets

  db_username = "admin"
  db_password = "admin123"
}

module "alb" {
  source = "./modules/alb"

    vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnets
}

module "ec2" {
  source = "./modules/ec2"

    vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnets[0]

  alb_sg_id = module.alb.alb_sg_id
  db_sg_id  = module.rds.db_sg_id

  instance_profile = module.iam.ec2_instance_profile
  target_group_arn = module.alb.target_group_arn

  bucket_name = module.s3.bucket_name

  key_name = "photoshare-key"
}
module "s3" {
  source = "./modules/s3"

  bucket_name = "photoshare-assets-12345"  # must be globally unique
}
module "lambda" {
  source = "./modules/lambda"

  lambda_role_arn = module.iam.lambda_role_arn
  bucket_name     = module.s3.bucket_name
  alb_dns         = module.alb.alb_dns_name

  lambda_zip_path = "lambda.zip"
}
module "cloudwatch" {
  source = "./modules/cloudwatch"

  ec2_instance_id       = module.ec2.instance_id
  lambda_function_name = module.lambda.lambda_name
}
