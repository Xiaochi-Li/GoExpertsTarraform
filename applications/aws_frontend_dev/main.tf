
terraform {

  # cloud {
  #   organization = "sean-li-terraform-cloud-learning"

  #   workspaces {
  #     name = "aws_frontend_dev"
  #   }
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.0.0"
    }
  }
}

locals {
  zone = "xiaochiligoexpert.link"
}

module "cloudfront_s3_website_with_domain" {
  source = "../../modules/aws-s3-cloudfront"
  // TODO - replace the var name domain_name to sub_domain_name
  domain_name = "dev.${local.zone}"
  bucket_name = "dev.${local.zone}"
  common_tags = { Project = "goexperts-${terraform.workspace}" }
  aws_region  = "ap-southeast-2"
  environment = "dev"
  zone        = local.zone
}
