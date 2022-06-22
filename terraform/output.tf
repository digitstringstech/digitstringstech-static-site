output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.website_bucket_config.website_endpoint
}

output "website_domain" {
  value = aws_s3_bucket_website_configuration.website_bucket_config.website_domain
}

output "hosted_zone_id" {
  value = aws_s3_bucket.website_bucket.hosted_zone_id
}
