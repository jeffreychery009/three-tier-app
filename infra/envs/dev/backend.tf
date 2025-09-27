terraform {
  backend "s3" {
    bucket         = "tfstate-jeffreychery-us-east-1"
    key            = "three-tier/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
