output "api_url" {
  value = aws_apigatewayv2_api.this.api_endpoint
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "alb_arn" {
  value = aws_lb.this.arn
}

output "sg_alb"{
  value = aws_security_group.alb.id
}

output "lambda_name" {
  value = aws_lambda_function.catalog.function_name
}

output "lambda_role_name" {
  value = aws_iam_role.lambda.name
}

output "ecs_task_role_name" {
  value =  aws_iam_role.ecs_task_role.name 
}