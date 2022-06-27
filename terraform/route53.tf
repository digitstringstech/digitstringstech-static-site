resource "aws_route53_zone" "primary" {
  name = var.root_domain_name
  tags = var.common_tags
}

resource "aws_route53_record" "email_cname" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "email"
  type    = "CNAME"
  ttl     = "300"

  records = ["email.secureserver.net"]
}

resource "aws_route53_record" "email_srv" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = ""
  type    = "SRV"
  ttl     = "300"

  records = ["100 1 443 autodiscover.secureserver.net"]
}

resource "aws_route53_record" "email_txt" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = ""
  type    = "TXT"
  ttl     = "300"

  records = ["D1411332", "v=spf1 include:secureserver.net -all"]
}

resource "aws_route53_record" "email_mx" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = ""
  type    = "MX"
  ttl     = "300"

  records = ["0 smtp.secureserver.net", "10 mailstore1.secureserver.net"]
}

// This Route53 record will point at our CloudFront distribution.
# resource "aws_route53_record" "www" {
#   zone_id = aws_route53_zone.primary.zone_id
#   name    = var.www_domain_name
#   type    = "A"

#   alias {
#     name                   = aws_cloudfront_distribution.www_distribution.domain_name
#     zone_id                = aws_cloudfront_distribution.www_distribution.hosted_zone_id
#     evaluate_target_health = false
#   }
# }

# resource "aws_route53_record" "root" {
#   zone_id = aws_route53_zone.primary.zone_id
#   name    = var.root_domain_name
#   type    = "A"

#   alias {
#     name                   = aws_cloudfront_distribution.www_distribution.domain_name
#     zone_id                = aws_cloudfront_distribution.www_distribution.hosted_zone_id
#     evaluate_target_health = false
#   }
# }
