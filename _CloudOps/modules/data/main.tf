# modulo de data

#se crea tabla para ejemplo "catalog" a ser accedida por lambda
resource "aws_dynamodb_table" "catalog" {
  name           = "catalog-${var.environment}"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}


#se deja planteado el uso de dax (caching para dynamodb) y aurora (base relacional)


/*

resource "aws_dax_cluster" "catalog" {
  cluster_name           = "catalog-dax-${var.environment}"
  node_type              = "dax.t3.small"
  replication_factor     = 2
  iam_role_arn           = aws_iam_role.dax_role.arn
  subnet_group_name      = aws_dax_subnet_group.this.name

}

resource "aws_dax_subnet_group" "this" {
  name       = "dax-subnets-${var.environment}"
  subnet_ids = var.private_subnets
}

resource "aws_iam_role" "dax_role" {
  name = "dax-role-${var.environment}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "dax.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "dax_access" {
  role       = aws_iam_role.dax_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}


resource "aws_rds_subnet_group" "aurora" {
  name       = "aurora-subnets-${var.environment}"
  subnet_ids = var.private_subnets

  tags = {
    Name = "aurora-subnets-${var.environment}"
  }
}

resource "aws_rds_cluster" "aurora" {
  cluster_identifier = "aurora-${var.environment}"

  engine         = "aurora-mysql"
  engine_version = "8.0.mysql_aurora.3.05.11"

  engine_mode = "provisioned"

  master_username = var.db_master_user
  master_password = var.db_master_password
  database_name   = "catalogdb"

  db_subnet_group_name   = aws_rds_subnet_group.aurora.name
  vpc_security_group_ids = [var.backend_sg_id]

  backup_retention_period = 7
  skip_final_snapshot     = true

  serverlessv2_scaling_configuration {
    min_capacity = 0.5   # ACUs
    max_capacity = 4.0
  }

  tags = {
    Name = "aurora-${var.environment}"
  }
}


*/

#permisos para la lambda acceder a la tabla dynamodb (y dax si se usa)
resource "aws_iam_policy" "lambda_dynamo_policy" {
  name = "lambda-dynamo-policy-${var.environment}"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = [
          aws_dynamodb_table.catalog.arn
        ]
      },
    /*  {
        Effect = "Allow"
        Action = [
          "dax:DescribeClusters",
          "dax:Connect"
        ]
        Resource = aws_dax_cluster.catalog.arn
      }*/
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_attach_dynamo" {
  role       = var.lambda_role_name
  policy_arn = aws_iam_policy.lambda_dynamo_policy.arn
}


/*
resource "aws_iam_policy" "ecs_aurora_policy" {
  name = "ecs-aurora-policy-${var.environment}"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "rds-data:ExecuteStatement",
          "rds-data:BatchExecuteStatement",
          "rds-data:BeginTransaction",
          "rds-data:CommitTransaction",
          "rds-data:RollbackTransaction"
        ]
        Resource = aws_rds_cluster.aurora.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_attach_aurora" {
  role       = var.ecs_task_role_name
  policy_arn = aws_iam_policy.ecs_aurora_policy.arn
}
*/
