# ---------------------------
# SECRET METADATA
# ---------------------------
resource "aws_secretsmanager_secret" "db_secret" {
  name        = "photoshare/db/credentials"
  description = "Database credentials for PhotoSharing App"
}

# ---------------------------
# SECRET VALUE (JSON)
# ---------------------------
resource "aws_secretsmanager_secret_version" "db_secret_value" {
  secret_id = aws_secretsmanager_secret.db_secret.id

  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
    engine   = "mysql"
    host     = var.db_host
    port     = 3306
    dbname   = var.db_name
  })
}
