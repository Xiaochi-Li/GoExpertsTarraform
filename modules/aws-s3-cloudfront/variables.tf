variable "environment" {
  type        = string
  description = "The environment (uat, prod, test, etc.)  for the website."
}

variable "domain_name" {
  type        = string
  description = "The domain name for the website."
}

variable "bucket_name" {
  type        = string
  description = "The name of the bucket without the www. prefix. Normally domain_name."
}

variable "common_tags" {
  description = "Common tags you want applied to all components."
  default = {
  }
}

variable "aws_region" {
  description = "The region of your website except for the acm, which MUST be us-east-1"
  type        = string
}

variable "zone" {
  description = "The domian name"
  type        = string
}
