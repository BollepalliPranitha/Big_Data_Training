resource "aws_s3_bucket" "prani-tf-test" {
  bucket = "pranithab-tf-test-bucket"

  tags = {
    Name        = "Pb bucket"
    Environment = "Dev"
  }
}
terraform {
  backend "s3" {
    bucket   = "pranithab-tf-test-bucket"
    key      = "terraform.tfstate"
    region   = "us-east-1"
    

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }
}