variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "bancolombia-vpc"
  default     = "technical-test-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}
variable "eks_ami_type"{
  description="AMi for the nodes"
  default="AL2023_x86_64_STANDARD"
}

variable "private_subnets" {
  description = "Private subnets CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  description = "Public subnets CIDR blocks"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  default     = "eks-cluster-bancolombia"
}

variable "eks_security_group_name" {
  description = "name for the eks security group"
  default     = "eks_sg"
}

variable "alb_security_group_name" {
  description = "name for the app load balancer"
  default     = "alb_sg"
}

variable "eks_cluster_version" {
  description = "EKS cluster version"
  default     = "1.21"
}

variable "eks_desired_capacity" {
  description = "Desired capacity for EKS nodes"
  default     = 2
}

variable "eks_max_capacity" {
  description = "Maximum capacity for EKS nodes"
  default     = 3
}
variable "eks_instance_types" {
  description = "Instance type for EKS nodes"
  default     = "t3.micro"
}
variable "eks_min_capacity" {
  description = "Minimum capacity for EKS nodes"
  default     = 1
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  default     = "Employees"
}

variable "alb_name" {
  description = "Name of the Application Load Balancer"
  default     = "my-alb"
}

variable "lb_type" {
  description = "load balancer type"
  default     = "application"
}

/*variable "alb_logs_bucket" {
  description = "S3 bucket for ALB access logs"
  default     = "my-alb-logs"
}*/

variable "certificate_arn" {
  description = "ARN of the SSL certificate for ALB"
  default     = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"
}

variable "target_id_1" {
  description = "Target ID for the first instance"
  default     = "i-0123456789abcdefg"
}

variable "target_id_2" {
  description = "Target ID for the second instance"
  default     = "i-a1b2c3d4e5f6g7h8i"
}

variable "eks" {
  description = "Target ID for the second instance"
  default     = "i-a1b2c3d4e5f6g7h8i"
}
