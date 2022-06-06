
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.0.0"
    }
  }
}

/* for resourses required in different region, has to create an aws provider for each region, give an `alias`, referece 
*/
provider "aws" {
  # us-east-1 instance for ACM
  region = "us-east-1"
  alias  = "us_east_1"
}
