
terraform {

  cloud {
    organization = "sean-li-terraform-cloud-learning"

    workspaces {
      name = "go-expert-front-end-prod"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.0.0"
    }
  }
}
