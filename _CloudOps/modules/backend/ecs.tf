#ecs cluster para beckend

resource "aws_ecs_cluster" "this" {
  name = "backend-cluster-${var.environment}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}


#se crean los roles de iam para las task y la ejecucion de las task. Se hace para demostrar luego en 
#el modulo data la habilitación de permisos a las dbs

resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-role-${var.environment}"

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
  name = "ecs-execution-role-${var.environment}"

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