# iam role 
# -----------------------
# EC2 TRUST POLICY
# -----------------------
data "aws_iam_policy_document" "ec2_trust" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# -----------------------
# EC2 ROLE
# -----------------------
resource "aws_iam_role" "ec2_role" {
  name               = "iam_role_ec2"
  assume_role_policy = data.aws_iam_policy_document.ec2_trust.json
}

# Attach permissions to EC2 role
resource "aws_iam_role_policy_attachment" "ec2_s3" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "ec2_secrets" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSSecretsManagerReadOnlyAccess"
}

# EC2 instance profile (needed to attach role to EC2)
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
}

# -----------------------
# LAMBDA TRUST POLICY
# -----------------------
data "aws_iam_policy_document" "lambda_trust" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# -----------------------
# LAMBDA ROLE
# -----------------------
resource "aws_iam_role" "lambda_role" {
  name               = "iam_role_lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust.json
}

# Attach permissions to Lambda role
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_s3" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
