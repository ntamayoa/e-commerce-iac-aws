variable "bucket_name" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "environment" {
  type = string
}

variable "cloudfront_arn" {
  type = string
}

variable "vpc_id" {
  type = string
}