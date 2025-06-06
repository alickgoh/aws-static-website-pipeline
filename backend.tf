terraform {
  backend "s3" {
    bucket         = "terraform-state-gohkl"
    key            = "static-website/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-locks"
  }
}
