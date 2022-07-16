terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.0.0"
    }
  }
}
data "aws_ssm_parameter" "db_connection" {
  name = "	GO_EXPERT_DB_CONNECTION_STRING"
}

data "aws_availability_zones" "available" {}

module "aws-alb-ecs" {
  source   = "../../modules/aws-alb-ecs"
  vpc_cidr = "10.0.0.0/16"
  // what happen if I change AZ to only sydney
  vpc_azs            = data.aws_availability_zones.available.names
  availability_zones = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
  private_subnets    = ["10.0.0.0/20", "10.0.16.0/20"]
  public_subnets     = ["10.0.32.0/20", "10.0.48.0/20"]
  application_name   = "go-expert-backend"
  aws_region         = "ap-southeast-2"
  image              = "public.ecr.aws/s2k7f9z4/go-expert-backend:latest"
  environment        = "dev"
  container_port     = 6000
  health_check_path  = "/api/experts/recommendationList"
  alb_tls_cert_arn   = "arn:aws:acm:ap-southeast-2:569265449628:certificate/e6bf74d9-68fd-49b5-a937-454ea5c70710"
  db_connection      = { name = "CONNECTION_STRING", valueFrom = "${data.aws_ssm_parameter.db_connection.arn}" }
}
