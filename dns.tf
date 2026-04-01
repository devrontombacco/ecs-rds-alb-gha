# ACM Cert

resource "aws_acm_certificate" "cert" {
  domain_name       = "myawsproject.xyz"
  validation_method = "DNS"

  tags = {
    Name = "${var.vpc_name}-cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Cert Validation Record

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = "Z0687581116E73SK0SFZ9"
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

# ACM Cert Validation

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}


# Route53 Record for ALB

resource "aws_route53_record" "app" {
  zone_id = "Z0687581116E73SK0SFZ9"
  name    = "myawsproject.xyz"
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}
