#recurso de secret manager (ejemplos)
resource "aws_secretsmanager_secret" "backend" {
  name = "backend-secrets-${var.environment}"
}
