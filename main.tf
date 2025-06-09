provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_s3_bucket" "site_bucket" {
  bucket = "my-terraform-website-gohkl" # Must be globally unique

  tags = {
    Name        = "My Static Website Bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.site_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_policy" "site_policy" {
  bucket = aws_s3_bucket.site_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "PublicReadGetObject"
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.site_bucket.arn}/*"
    }]
  })
}

resource "aws_s3_object" "index_page" {
  bucket       = aws_s3_bucket.site_bucket.id
  key          = "index.html"
  source       = "index.html" # Path to your local file
  content_type = "text/html"
  
  # The etag is used to ensure the file is re-uploaded if it changes
  etag = filemd5("index.html")
}

output "website_endpoint" {
  value = "http://${aws_s3_bucket_website_configuration.site.website_endpoint}"
}

