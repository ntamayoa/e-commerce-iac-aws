variable "domain_name" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}