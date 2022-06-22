variable "region" {
  type        = string
  description = "AWS region"
  default     = "ap-south-1"
}

variable "www_domain_name" {
  type = string
  description = "www domain name for the website."
}

variable "root_domain_name" {
  type = string
  description = "Root domain name for the website."
}

variable "common_tags" {
  description = "Common tags you want applied to all components."
}
