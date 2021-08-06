#Defining the provider for Terraform. We will use only AWS resources.
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.38.0"
    }
  }
}

/**
 * main.tf
 * The main entry point for Terraform run
 */

# Using the AWS Provider
provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

/*
 * Outputs
 * Results from a successful Terraform run (terraform apply)
 */

# Returns the name of the ECR registry. We will use this variable in ECS
output "docker_registry" {
  value = aws_ecr_repository.app.repository_url
}
