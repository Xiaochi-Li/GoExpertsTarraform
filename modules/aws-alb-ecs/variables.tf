variable "application_name" {
  type        = string
  description = "the name of the application"
}

variable "aws_region" {
  description = "The region of your website except for the acm, which MUST be us-east-1"
  type        = string
}

variable "image" {
  type        = string
  description = "the name of the ecr image hosts on ECS"
}

variable "environment" {
  type        = string
  description = "the evironment"
}

variable "availability_zones" {
  type        = list(string)
  description = "A list of zvailability zones for a regin"

}
variable "container_port" {
  type        = number
  description = "the port that app is host in docker"
}

variable "private_subnets" {
  type        = list(string)
  description = "a list of subnets"
}

variable "public_subnets" {
  type        = list(string)
  description = "a list of subnets"
}

variable "vpc_cidr" {
  description = "CIDR for VPC"
  type        = string
}

variable "vpc_azs" {
  description = "Availabe zones for VPC"
  type        = list(string)
}

// notice this should be the Url path for testing
// eg: for http://go-expert/api/experts/recommendationList
// the path is "/api/experts/recommendationList"
variable "health_check_path" {
  description = "Http path for task health check"
  default     = ""
}
