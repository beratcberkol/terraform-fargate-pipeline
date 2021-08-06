/*
 * variables.tf
 * Variables that defined here will be used in other terraform files.
 */

# The AWS region
variable "region" {
  default = "eu-west-1"
}

# The AWS profile to use.
variable "aws_profile" {
  default="personal"
}

# Name of the application.
variable "app" {
  default = "sample-react-app"
}

# A map of the tags to apply to various resources.
variable "tags" {
  type = map(string)
    default = {
    "application" = "sample-react-app"
    "environment" = "development"
  }
}
