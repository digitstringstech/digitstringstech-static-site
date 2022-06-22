terraform {
  backend "s3" {
    profile = "ds"
    bucket  = "digitstringstech-terraform"
    key     = "prod/terraform.tfstate"
    region  = "ap-south-1"
  }
}