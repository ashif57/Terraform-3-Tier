resource "aws_lambda_function" "metadata_extractor" {
  function_name = "photoshare-metadata-extractor"
  role          = var.lambda_role_arn
  handler       = "lambda_handler.lambda_handler"
  runtime       = "python3.14"
  architectures = ["x86_64"]

  filename         = var.lambda_zip_path
  source_code_hash = filebase64sha256(var.lambda_zip_path)

  environment {
    variables = {
      S3_BUCKET = var.bucket_name
      ALB_DNS   = var.alb_dns
    }
  }

  tags = {
    Name = "photoshare-metadata-extractor"
  }
}
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.metadata_extractor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.bucket_name}"
}
resource "aws_s3_bucket_notification" "trigger_lambda" {
  bucket = var.bucket_name

  lambda_function {
    lambda_function_arn = aws_lambda_function.metadata_extractor.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}
