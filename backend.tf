terraform {
  backend "s3" {
    # Replace with your bucket name
    bucket = "my-terraform-state-lock-gohkl" 

    # This is the path to the state file inside the bucket
    key    = "global/s3/terraform.tfstate"

    # Replace with your bucket's region
    region = "ap-southeast-1"

    # Enable state locking. This will create a .tflock file in S3.
    # No DynamoDB table is needed!
    encrypt        = true
  }
}
