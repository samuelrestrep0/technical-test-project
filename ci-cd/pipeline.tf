provider "aws" {
  region = var.aws_region  # Utiliza la región definida en variables.tf
}

# Bucket S3 para almacenar artefactos
resource "aws_s3_bucket" "artifacts_bucket" {
  bucket = "${var.project_name}-artifacts"

  tags = {
    Name        = "${var.project_name}-artifacts"
    Environment = "dev"
  }
}

resource "aws_s3_bucket_acl" "artifacts_bucket_acl" {
  bucket = aws_s3_bucket.artifacts_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "artifacts_bucket_versioning" {
  bucket = aws_s3_bucket.artifacts_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Rol IAM para CodeBuild
resource "aws_iam_role" "codebuild_role" {
  name = "${var.project_name}_codebuild_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "codebuild.amazonaws.com"
      }
    }]
  })
}

# Políticas IAM para CodeBuild
resource "aws_iam_policy" "codebuild_policy" {
  name   = "${var.project_name}_codebuild_policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "eks:DescribeCluster",
        "eks:DescribeNodegroup",
        "eks:ListClusters",
        "eks:ListNodegroups",
        "eks:UpdateNodegroupConfig",
        "eks:UpdateClusterConfig",
        "eks:DescribeUpdate",
        "s3:GetObject",
        "s3:PutObject"
      ],
      Resource = "*"
    }]
  })
}

# Asignar política al rol de CodeBuild
resource "aws_iam_role_policy_attachment" "codebuild_role_policy_attach" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_policy.arn
}

# Proyecto de CodeBuild para despliegue
resource "aws_codebuild_project" "deploy_project" {
  name         = "${var.project_name}_deploy"
  service_role = aws_iam_role.codebuild_role.arn

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:4.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }

  source {
    type      = "S3"
    location  = aws_s3_bucket.artifacts_bucket.bucket
    buildspec = "buildspec-deploy.yml"
  }

  artifacts {
    type       = "S3"
    location   = aws_s3_bucket.artifacts_bucket.bucket
    packaging  = "ZIP"
    path       = "build-artifacts"
  }
}

# Pipeline de CI/CD en AWS CodePipeline
resource "aws_codepipeline" "ci_cd_pipeline" {
  name     = "${var.project_name}_pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.artifacts_bucket.bucket
    type     = "S3"
  }

  # Etapa de origen
  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "S3"
      version          = "1"
      configuration = {
        S3Bucket    = aws_s3_bucket.artifacts_bucket.bucket
        S3ObjectKey = "source.zip"
      }
      output_artifacts = ["source_output"]
    }
  }

  # Etapa de construcción
  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      configuration = {
        ProjectName = aws_codebuild_project.deploy_project.name
      }
    }
  }

  # Etapa de despliegue
  stage {
    name = "Deploy"
    action {
      name             = "Deploy"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["build_output"]
      configuration = {
        ProjectName = aws_codebuild_project.deploy_project.name
      }
    }
  }
}

# Rol IAM para CodePipeline
resource "aws_iam_role" "codepipeline_role" {
  name = "CodePipelineRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "codepipeline.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# Políticas necesarias para CodePipeline
resource "aws_iam_policy" "codepipeline_policy" {
  name   = "${var.project_name}_codepipeline_policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:*", "codebuild:*", "codedeploy:*", "eks:*"],
        Resource = "*"
      }
    ]
  })
}

# Asignar política al rol de CodePipeline
resource "aws_iam_role_policy_attachment" "codepipeline_role_policy_attach" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_policy.arn
}
