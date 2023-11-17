resource "aws_route53_zone" "front" {
  name = var.domain
  force_destroy = true
}

resource "aws_route53_record" "front" {
  zone_id = aws_route53_zone.front.zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = var.lb_dns_name
    zone_id                = var.lb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "jenkins" {
  zone_id = aws_route53_zone.front.zone_id
  name    = "jenkins.entry-equus.site"
  type    = "A"
  ttl     = "300"
  records = ["15.164.217.147"]
}

resource "aws_route53_record" "cert_validation" {
  name    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_type
  zone_id = aws_route53_zone.front.zone_id
  records = [tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_value]
  ttl     = 60
}