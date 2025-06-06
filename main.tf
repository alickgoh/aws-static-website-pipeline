# Configure the Terraform backend for remote state storage and locking
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-gkl" # <-- PASTE YOUR STATE BUCKET NAME HERE
    key            = "website/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-locks"
  }
}

# Configure the AWS provider
provider "aws" {
  region = "ap-southeast-1"
}

# Create a unique S3 bucket to host the website files
resource "aws_s3_bucket" "website_bucket" {
  # Bucket names must be globally unique. A random suffix helps.
  bucket_prefix = "my-static-website-"

  tags = {
    Project     = "Static Website Lab"
    ManagedBy   = "Terraform"
  }
}

# Configure the S3 bucket for static website hosting
resource "aws_s3_bucket_website_configuration" "website_configuration" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }
}

# Apply a public-read policy to the S3 bucket to allow visitors to see the site
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.website_bucket.arn}/*"
      }
    ]
  })
}

# Enable public access block to be managed by this policy
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Output the website URL for easy access
output "website_url" {
  value       = aws_s3_bucket_website_configuration.website_configuration.website_endpoint
  description = "The URL of the deployed static website."
}
