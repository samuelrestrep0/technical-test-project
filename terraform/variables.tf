variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "Name of the VPC"
  default     = "my-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
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
  default     = "my-eks-cluster"
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

variable "eks_min_capacity" {
  description = "Minimum capacity for EKS nodes"
  default     = 1
}

variable "eks_instance_type" {
  description = "Instance type for EKS nodes"
  default     = "t3.medium"
}

variable "key_name" {
  description = "Key pair name for EC2 instances"
  default     = "my-key-pair"
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  default     = "MyDynamoDBTable"
}

variable "alb_name" {
  description = "Name of the Application Load Balancer"
  default     = "my-alb"
}
