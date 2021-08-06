# The tag mutability setting for the repository (MUTABLE for tagging image from pipeline with the same tag)
variable "image_tag_mutability" {
  type        = string
  default     = "MUTABLE"
}

# create an ECR repo at the app/image level
resource "aws_ecr_repository" "app" {
  name                 = var.app
  image_tag_mutability = var.image_tag_mutability
}


