resource "aws_route53_record" "equus" {
  zone_id = var.zone_id
  name    = "${var.record_name}.entry-equus.site"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.equus.public_ip]
}