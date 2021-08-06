/*
 * variables.tf
 * Common variables to use in various Terraform files (*.tf)
 */

# The AWS region to use for the dev environment's infrastructure
variable "region" {
  default = "eu-west-1"
}

# Tags for the infrastructure
variable "tags" {
  type = map(string)
    default = {
    "application" = "sample-react-app"
    "environment" = "development"
  }
}

# The application's name
variable "app" {
  default = "sample-react-app"
}

# The environment that is being built
variable "environment" {
  default = "development"
}
# The port the container will listen on, used for load balancer health check
variable "container_port" {
  default = "3000"
}

# The port the load balancer will listen on
variable "lb_port" {
  default = "80"
}

# The load balancer protocol
variable "lb_protocol" {
  default = "HTTP"
}

# Network configuration

# The VPC to use for the Fargate cluster
variable "vpc" {
  default = "vpc-475aec3e"
}

# The private subnets, minimum of 2, that are a part of the VPC(s)
variable "private_subnets" {
  default = "subnet-09684453,subnet-f74dbebc"
}

# The public subnets, minimum of 2, that are a part of the VPC(s)
variable "public_subnets" {
  default = "subnet-09684453,subnet-f74dbebc"
}