terraform {
  required_version = ">= 0.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0, < 4.0.0"
    }
  }
}

provider "aws" {
  profile = "ds"
  region  = var.region
}

# For cloudfront, the acm has to be created in us-east-1 or it will not work
# provider "aws" {
#   profile = "ds"
#   region  = "us-east-1"
#   alias   = "acm_provider"
# }
