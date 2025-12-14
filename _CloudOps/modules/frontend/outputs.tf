output "frontend_url" {
  value = module.cdn.cloudfront_domain
}

output "frontend_bucket" {
  value = module.app.s3_bucket_domain
}