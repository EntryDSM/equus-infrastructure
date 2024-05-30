resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = var.certificate_arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}