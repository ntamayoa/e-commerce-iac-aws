#API Gateway para exponer los servicios de backend

#se usa HTTPV2 por menor costo y menor latencia que REST API Gateway

resource "aws_apigatewayv2_api" "this" {
  name          = "backend-api-${var.environment}"
  protocol_type = "HTTP"
}

#ruta ejemplo de lambda para el servicio de catalogo
resource "aws_apigatewayv2_integration" "catalog" {
  api_id           = aws_apigatewayv2_api.this.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.catalog.invoke_arn
}
resource "aws_apigatewayv2_route" "catalog" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "ANY /catalog/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.catalog.id}"
}

#ruta para el servicio de checkout detras de un VPC Link apuntando al ALB del backend
resource "aws_apigatewayv2_vpc_link" "this" {
  name               = "backend-vpc-link-${var.environment}"
  subnet_ids         = var.private_subnets
  security_group_ids = [aws_security_group.alb.id]
}

resource "aws_apigatewayv2_integration" "checkout" {
  api_id             = aws_apigatewayv2_api.this.id
  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
  integration_uri    = aws_lb_listener.http.arn
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.this.id
}

resource "aws_apigatewayv2_route" "checkout" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "ANY /checkout/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.checkout.id}"

  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito.id #esta ruta (checkut) esta protegida por cognito. si debe tener el usuario logeado
}

#stage por defecto que hace auto deploy de los cambios. Para producción se usaria stage de prod
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = "$default"
  auto_deploy = true
}


data "aws_region" "current" {}

#se integra el authorizer de cognito (user pools) para proteger la ruta de checkout
resource "aws_apigatewayv2_authorizer" "cognito" {
  api_id = aws_apigatewayv2_api.this.id
  name   = "cognito-authorizer-${var.environment}"
  authorizer_type = "JWT"

  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    audience = [aws_cognito_user_pool_client.this.id]
    issuer = "https://cognito-idp.${data.aws_region.current.name}.amazonaws.com/${aws_cognito_user_pool.this.id}"

  }
}





