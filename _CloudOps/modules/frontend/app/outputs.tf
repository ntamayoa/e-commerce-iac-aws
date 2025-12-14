output "s3_bucket_domain" {
  value = aws_s3_bucket.static.bucket_regional_domain_name
}

output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.this.name
}
