locals {
  domain   = "entry-equus.site"
  stag_dns_name = module.ecs_stag.lb_dns_name
  stag_zone_id  = module.ecs_stag.lb_zone_id

  prod_dns_name = module.ecs_prod.lb_dns_name
  prod_zone_id = module.ecs_prod.lb_zone_id
}

resource "aws_route53_zone" "front" {
  name = local.domain
  force_destroy = true
}

resource "aws_acm_certificate" "cert" {
  domain_name       = local.domain
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}

resource "aws_route53_record" "cert_validation" {
  name    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_type
  zone_id = aws_route53_zone.front.zone_id
  records = [tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_value]
  ttl     = 60
}

module "stag_route53" {
  source = "./modules/domain"

  domain      = local.domain
  lb_dns_name = local.stag_dns_name
  lb_zone_id  = local.stag_zone_id
  environment = "stag"

  certificate_arn = aws_acm_certificate.cert.arn
  zone_id = aws_route53_zone.front.zone_id
}

module "prod_route53" {
  source = "./modules/domain"

  domain      = local.domain
  lb_dns_name = local.prod_dns_name
  lb_zone_id  = local.prod_zone_id
  environment = "prod"

  certificate_arn = aws_acm_certificate.cert.arn
  zone_id = aws_route53_zone.front.zone_id
}

