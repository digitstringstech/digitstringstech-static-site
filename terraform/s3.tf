# resource "aws_s3_bucket" "website_bucket" {
#   // Our bucket's name is going to be the same as our site's domain name.
#   bucket = var.www_domain_name
# }

# resource "aws_s3_bucket_website_configuration" "website_bucket_config" {
#   bucket = aws_s3_bucket.website_bucket.id

#   index_document {
#     suffix = "index.html"
#   }

#   error_document {
#     key = "error.html"
#   }
# }

# resource "aws_s3_bucket_acl" "website_bucket_acl" {
#   bucket = aws_s3_bucket.website_bucket.id
#   acl    = "public-read"
# }

# resource "aws_s3_bucket_policy" "allow_public_get_access" {
#   bucket = aws_s3_bucket.website_bucket.id
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid       = "PublicReadGetObject"
#         Effect    = "Allow"
#         Principal = "*"
#         Action    = "s3:GetObject"
#         Resource = [
#           aws_s3_bucket.website_bucket.arn,
#           "${aws_s3_bucket.website_bucket.arn}/*",
#         ]
#       },
#     ]
#   })
# }

# resource "aws_s3_bucket_cors_configuration" "example" {
#   bucket = aws_s3_bucket.website_bucket.id

#   cors_rule {
#     allowed_methods = ["GET"]
#     allowed_origins = ["*"]
#   }
# }

#Upload files of your static website
# resource "aws_s3_object" "html" {
#   for_each = fileset("../static-site/", "*")

#   bucket       = aws_s3_bucket.website_bucket.bucket
#   key          = each.value
#   source       = "../static-site/${each.value}"
#   etag         = filemd5("../static-site/${each.value}")
#   content_type = "text/html"
# }

module "s3-static-website" {
  source  = "cn-terraform/s3-static-website/aws"
  version = "0.0.15"
  # insert the 3 required variables here
  name_prefix         = "digitstringstech"
  website_domain_name = var.root_domain_name

  providers = {
    aws.main         = aws.main
    aws.acm_provider = aws.acm_provider
  }

  aws_accounts_with_read_view_log_bucket = [data.aws_caller_identity.current.account_id]

  create_acm_certificate     = false
  acm_certificate_arn_to_use = aws_acm_certificate.certificate.arn

  create_route53_hosted_zone = false
  route53_hosted_zone_id     = aws_route53_zone.primary.zone_id
}

module "template_files" {
  source   = "hashicorp/dir/template"
  base_dir = "../${path.module}/static-site"
}

resource "aws_s3_object" "static_files" {
  for_each = module.template_files.files

  bucket       = module.s3-static-website.website_bucket_id
  key          = each.key
  content_type = each.value.content_type

  # The template_files module guarantees that only one of these two attributes
  # will be set for each file, depending on whether it is an in-memory template
  # rendering result or a static file on disk.
  source  = each.value.source_path
  content = each.value.content

  # Unless the bucket has encryption enabled, the ETag of each object is an
  # MD5 hash of that object.
  etag = each.value.digests.md5
}



