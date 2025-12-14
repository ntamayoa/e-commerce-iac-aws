# main que llama a todos los modulos de cada capa

provider "aws" {
  region  = "us-east-1"
}

# por buenas practicas se define un backend remoto con s3. 
# Este fue el unico recurso creado por fuera del IaC actual
terraform {
  backend "s3" {
    bucket         = "cloudops-prueba-tecnica-pragma"
    key            = "dev/frontend.tfstate"
    region         = "us-east-1"
    use_lockfile   = true
  }
}


variable "environment" {
  type        = string 
  description = "Enviroment to deploy"
  default = "dev"
}

# modulo "base" de redes
module "network" {
  source      = "../../modules/network"
  environment = var.environment
}

#modulo front, usa outputs de network
module "frontend" {
  source = "../../modules/frontend"

  domain_name    = "jfk-demos.com"
  bucket_name    = "jfk-demo-frontend-static-dev"
  public_subnets = module.network.public_subnets
  vpc_id         = module.network.vpc_id
  environment    = var.environment
}

# modulo backend, usa outputs de network
module "backend" {
  source = "../../modules/backend"

  environment      = var.environment
  vpc_id           = module.network.vpc_id
  public_subnets    = module.network.public_subnets
  private_subnets  = module.network.private_subnets
}

#modulo data, usa output de network y backend (para conexiones con las db)
module "data" {
  source = "../../modules/data"

  environment         = var.environment
  private_subnets     = module.network.private_subnets
  lambda_role_name    = module.backend.lambda_role_name
  ecs_task_role_name  = module.backend.ecs_task_role_name
  #db_master_user      = var.db_master_user
  #db_master_password  = var.db_master_password
  aurora_instance_count = 1
  backend_sg_id       = module.backend.sg_alb
}

