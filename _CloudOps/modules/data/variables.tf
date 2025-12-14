variable "environment" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "lambda_role_name" {
  type = string
}

variable "ecs_task_role_name" {
  type = string
}

variable "db_master_user" {
  type = string
  default = ""
}

variable "db_master_password" {
  type = string
  default = ""
}

variable "aurora_instance_count" {
  type    = number
  default = 1
}

variable "backend_sg_id" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
