# se deja el ecs cluster. La idea es que el pipeline de github actions despliegue la task dentro del cluster
# cuando haya una nueva version de la aplicacions

resource "aws_ecs_cluster" "this" {
  name = "frontend-cluster-${var.environment}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
