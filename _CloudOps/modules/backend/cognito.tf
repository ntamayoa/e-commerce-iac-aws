
#cognito user pools
# en producción convendria hacer conexión con un PId como google o facebook

resource "aws_cognito_user_pool" "this" {
  name = "backend-user-pool-${var.environment}"

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = false
    require_uppercase = true
  }

  auto_verified_attributes = ["email"]

  mfa_configuration = "OFF"
}

resource "aws_cognito_user_pool_client" "this" {
  name         = "backend-user-pool-client-${var.environment}"
  user_pool_id = aws_cognito_user_pool.this.id

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]

  prevent_user_existence_errors = "ENABLED"
}
