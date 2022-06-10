resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  // has to be in "us-east-1" otherwise cloudfron won't use it
  provider = aws.acm_provider

  tags = var.common_tags

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_acm_certificate_validation" "main" {
  provider                = aws.acm_provider
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
