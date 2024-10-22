module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "v3.15.0"  # Usa la última versión estable

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = false  # Para tener un NAT Gateway en cada subred pública
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_security_group" "eks_sg" {
  name        = "eks_security_group"
  description = "Allow traffic to EKS nodes"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "alb_security_group"
  description = "Allow traffic to ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "v19.0.0"  # Usa la última versión estable

  cluster_name    = var.eks_cluster_name
  cluster_version = var.eks_cluster_version
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  node_groups = {
    eks_nodes = {
      desired_capacity = var.eks_desired_capacity
      max_capacity     = var.eks_max_capacity
      min_capacity     = var.eks_min_capacity

      instance_type = var.eks_instance_type
      key_name      = var.key_name

      # Añadir el grupo de seguridad para los nodos de EKS
      security_groups = [aws_security_group.eks_sg.id]
    }
  }

  manage_aws_auth = true
}

module "dynamodb" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "v2.0.0"  # Usa la última versión estable

  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"  # Modelo de pago por uso (opcional)
  
  attribute {
    name = "id"
    type = "S"  # Tipo de atributo: S para String
  }

  hash_key = "id"

  tags = {
    Name = var.dynamodb_table_name
  }
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "v8.0.0"

  name               = var.alb_name
  load_balancer_type = "application"
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      target_type = "ip"
    },
    {
      port        = 443
      protocol    = "HTTPS"
      target_type = "ip"
    }
  ]

  tags = {
    Name = var.alb_name
  }

  security_groups = [aws_security_group.alb_sg.id]
}
