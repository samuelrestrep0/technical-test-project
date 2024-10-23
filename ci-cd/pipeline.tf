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

resource "aws_codepipeline" "ci_cd_pipeline" {
  name     = "${var.project_name}_pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

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
        ProjectName = aws_codebuild_project.build_project.name
      }
    }
  }

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


resource "aws_codebuild_project" "deploy_project" {
  name          = "${var.project_name}_deploy"
  service_role  = aws_iam_role.codebuild_role.arn
  
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
    type = "S3"
    location = aws_s3_bucket.artifacts_bucket.bucket
    packaging = "ZIP"
    path = "build-artifacts"
  }
}

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
