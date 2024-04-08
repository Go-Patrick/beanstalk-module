data "aws_route53_zone" "app_zone" {
  name = var.dns_zone
}

resource "aws_acm_certificate" "app_ssl_certificate" {
  domain_name = data.aws_route53_zone.app_zone.name
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "app_certificate_validation" {
  certificate_arn = aws_acm_certificate.app_ssl_certificate.arn
  validation_record_fqdns = [aws_route53_record.certificate_validate_record.fqdn]
}


resource "aws_route53_record" "certificate_validate_record" {
  name            = tolist(aws_acm_certificate.app_ssl_certificate.domain_validation_options)[0].resource_record_name
  records         = [ tolist(aws_acm_certificate.app_ssl_certificate.domain_validation_options)[0].resource_record_value ]
  type            = tolist(aws_acm_certificate.app_ssl_certificate.domain_validation_options)[0].resource_record_type
  ttl             = 60
  zone_id         = data.aws_route53_zone.app_zone.zone_id
}

resource "aws_route53_record" "app_new_record" {
  name    = var.dns_zone
  type    = "A"
  zone_id = data.aws_route53_zone.app_zone.zone_id

  alias {
    evaluate_target_health = false
    name                   = var.cname
    zone_id                = var.zone
  }
}
