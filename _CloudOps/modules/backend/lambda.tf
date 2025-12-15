
#ejemplo de lambda para el servicio de catalogo. Codigo "inline". Solo para despliegue inicial, actualizaciones desde el pipeline
data "archive_file" "lambda_zip_inline" {
  type        = "zip"
  output_path = "${path.module}/lambda_function.zip"  

  source {
    content  = <<-EOF
      exports.handler = async (event, context) => {
        return {
          statusCode: 200,
          body: JSON.stringify('Hello from Lambda!'),
        };
      };
    EOF
    filename = "index.js" 
  }
}

# Lambda function para el servicio de catalogo
resource "aws_lambda_function" "catalog" {
  function_name = "catalog-${var.environment}"
  runtime       = "nodejs18.x"
  handler       = "index.handler"
  role          = aws_iam_role.lambda.arn #rol creado en el modulo iam.tf

  filename         = data.archive_file.lambda_zip_inline.output_path
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip_inline.output_path)

  environment {
    variables = {
      SECRET_NAME = aws_secretsmanager_secret.backend.name #ejemplo uso de un secret manager dentro de la lambda
    }
  }
}