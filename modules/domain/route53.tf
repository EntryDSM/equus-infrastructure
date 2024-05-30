resource "aws_route53_record" "front" {
  zone_id = var.zone_id
  name    = "${var.environment}.${var.domain}"
  type    = "A"

  alias {
    name                   = var.lb_dns_name
    zone_id                = var.lb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cert_validation" {
  name    = tolist(var.domain_validation_options)[0].resource_record_name
  type    = tolist(var.domain_validation_options)[0].resource_record_type
  zone_id = var.zone_id
  records = [tolist(var.domain_validation_options)[0].resource_record_value]
  ttl     = 60
}