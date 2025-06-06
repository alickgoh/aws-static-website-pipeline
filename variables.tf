variable "bucket_name" {
  description = "Name of the S3 bucket for static website"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "ap-southeast-1"
}
