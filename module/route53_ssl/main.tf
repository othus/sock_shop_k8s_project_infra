# Import Route53 Hosted Zone from my aws account
data "aws_route53_zone" "sockshop_zone" {
  name         = var.domain_name
  private_zone = false
}

# Create prod record from Route 53 zone
resource "aws_route53_record" "prod" {
  zone_id = data.aws_route53_zone.sockshop_zone.zone_id
  name    = var.domain_name1
  type    = "A"
  alias {
    name                   = var.prod_dns_name
    zone_id                = var.prod_zone_id
    evaluate_target_health = false
  }
}
# Create Stage record from Route 53 zone
resource "aws_route53_record" "stage" {
  zone_id = data.aws_route53_zone.sockshop_zone.zone_id
  name    = var.domain_name2
  type    = "A"
  alias {
    name                   = var.stage_dns_name
    zone_id                = var.stage_zone_id
    evaluate_target_health = false
  }
}
# Create prometheus record from Route 53 zone
resource "aws_route53_record" "prometheus" {
  zone_id = data.aws_route53_zone.sockshop_zone.zone_id
  name    = var.domain_name3
  type    = "A"
  alias {
    name                   = var.prometheus_dns_name
    zone_id                = var.prometheus_zone_id
    evaluate_target_health = false
  }
}
# Create grafana record from Route 53 zone
resource "aws_route53_record" "grafana" {
  zone_id = data.aws_route53_zone.sockshop_zone.zone_id
  name    = var.domain_name4
  type    = "A"
  alias {
    name                   = var.grafana_dns_name
    zone_id                = var.grafana_zone_id
    evaluate_target_health = false
  }
}

# Creating Certifcate for entire Domain Name
resource "aws_acm_certificate" "sockshop-certificate" {
  domain_name               = var.domain_name
  subject_alternative_names = [var.domain_name5]
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

# Creating record set in Route53 for Domain Validation
resource "aws_route53_record" "sockshop-validation-record" {
  for_each = {
    for dvo in aws_acm_certificate.sockshop-certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  ttl             = 60
  zone_id         = data.aws_route53_zone.sockshop_zone.zone_id
}

# Creating instruction to validate ACM certificate
resource "aws_acm_certificate_validation" "sockshop-cert-validation" {
  certificate_arn         = aws_acm_certificate.sockshop-certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.sockshop-validation-record : record.fqdn]
}

