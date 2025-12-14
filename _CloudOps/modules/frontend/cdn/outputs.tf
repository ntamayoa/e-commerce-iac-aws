output "cloudfront_domain" {
  value = aws_cloudfront_distribution.this.domain_name
}

output "cloudfront_arn" {
  value = aws_cloudfront_origin_access_identity.this.iam_arn
}

output "zone_id" {
  value = aws_route53_zone.this.zone_id
}
