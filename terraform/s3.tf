resource "aws_s3_bucket" "website_bucket" {
  // Our bucket's name is going to be the same as our site's domain name.
  bucket = var.www_domain_name
}

resource "aws_s3_bucket_website_configuration" "website_bucket_config" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_acl" "website_bucket_acl" {
  bucket = aws_s3_bucket.website_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "allow_public_get_access" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = [
          aws_s3_bucket.website_bucket.arn,
          "${aws_s3_bucket.website_bucket.arn}/*",
        ]
      },
    ]
  })
}

resource "aws_s3_bucket_cors_configuration" "example" {
  bucket = aws_s3_bucket.website_bucket.id

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}

#Upload files of your static website
resource "aws_s3_bucket_object" "html" {
  for_each = fileset("../static-site/", "**/*.html")

  bucket       = aws_s3_bucket.website_bucket.bucket
  key          = each.value
  source       = "../static-site/${each.value}"
  etag         = filemd5("../static-site/${each.value}")
  content_type = "text/html"
}

# Print the files processed so far
output "fileset-results" {
  value = fileset("../static-site/", "**/*")
}




