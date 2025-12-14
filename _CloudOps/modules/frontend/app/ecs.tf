# se deja el ecs cluster. La idea es que el pipeline de github actions despliegue la task dentro del cluster
# cuando haya una nueva version de la aplicacions

resource "aws_ecs_cluster" "this" {
  name = "frontend-cluster-${var.environment}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}


resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-role-front-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}


resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs-execution-front-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

#permisos para ecs task execution role
resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
