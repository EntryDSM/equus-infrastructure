output "acm_arn" {
  value = aws_acm_certificate.cert.arn
}

output "domain_zone_id" {
  value = aws_route53_zone.front.zone_id
}