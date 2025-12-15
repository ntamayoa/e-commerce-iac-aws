variable "bucket_name" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "environment" {
  type = string
}

variable "oai_canonical_user_id" {
  type = string
}

variable "vpc_id" {
  type = string
}