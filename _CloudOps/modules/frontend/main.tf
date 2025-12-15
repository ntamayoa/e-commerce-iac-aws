# main de frontend que llama a los dos modulos principales

module "cdn" {
  source            = "./cdn"
  domain_name       = var.domain_name
  s3_bucket_domain  = module.app.s3_bucket_domain
  alb_dns_name      = module.app.alb_dns_name
  environment       = var.environment
}


module "app" {
  source          = "./app"
  bucket_name     = var.bucket_name
  public_subnets  = var.public_subnets
  environment     = var.environment
  oai_canonical_user_id  = module.cdn.oai_canonical_user_id
  vpc_id          = var.vpc_id #importante para el alb
}
