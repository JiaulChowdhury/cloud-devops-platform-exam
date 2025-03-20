terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket"  # Replace with your S3 bucket name
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"   # Replace with your DynamoDB table for locking
    encrypt        = true
  }
}
