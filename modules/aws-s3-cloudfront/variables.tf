variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-2"
}

variable "bucket_name" {
  description = "s3 bucket name"
  type        = string
  default     = "xiaochiligoexpert"
}

variable "domain_name" {
  description = "Route 53 domain name"
  type        = string
  default     = "xiaochiligoexpert.link"
}
