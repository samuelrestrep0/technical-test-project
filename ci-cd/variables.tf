variable "project_name" {
  description = "Nombre del proyecto"
  default     = "bancolombia-technical-test"
}

variable "aws_account_id" {
  description = "AWS Account ID"
  default     = "tu_aws_account_id"
}

variable "image_repo_name" {
  description = "Nombre del repositorio ECR para la imagen Docker"
  default     = "static-website"
}
