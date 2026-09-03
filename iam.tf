# ------------------------------------------------------------------
# ECS Task Execution Role (pull from ECR +  write to CloudWatch)
# ------------------------------------------------------------------

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.vpc_name}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# -------------------------------------------------------
# ECS Task Role 
# -------------------------------------------------------

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.vpc_name}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# ------------------------------------------------------------------
# GitHub OIDC Provider
# ------------------------------------------------------------------

resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

# ------------------------------------------------------------------
# GitHub Actions Deploy Role (OIDC)
# ------------------------------------------------------------------

resource "aws_iam_role" "github_actions_deploy" {
  name = "${var.vpc_name}-github-actions-deploy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = [
              "repo:devrontombacco/ecs-rds-alb-gha:ref:refs/heads/main",
              "repo:devrontombacco/ecs-rds-alb-gha:pull_request"
            ]
          }
        }
      }
    ]
  })
}

# ------------------------------------------------------------------
# Permissions for deploy role
# ------------------------------------------------------------------

resource "aws_iam_role_policy" "github_actions_deploy_policy" {
  name = "${var.vpc_name}-github-actions-deploy-policy"
  role = aws_iam_role.github_actions_deploy.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
        Resource = aws_ecr_repository.flask_app.arn
      },
      {
        Effect = "Allow"
        Action = [
          "ecs:DescribeTaskDefinition",
          "ecs:RegisterTaskDefinition"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecs:UpdateService",
          "ecs:DescribeServices"
        ]
        Resource = aws_ecs_service.flask-App.id
      },
      {
        Effect = "Allow"
        Action = "iam:PassRole"
        Resource = [
          aws_iam_role.ecs_task_execution_role.arn,
          aws_iam_role.ecs_task_role.arn
        ]
      },
      {
        Sid    = "TerraformStateBucketList"
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::devron-project9-tfstate-677276118863"
      },
      {
        Sid    = "TerraformStateObjectAccess"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "arn:aws:s3:::devron-project9-tfstate-677276118863/*"
        }, {
        Sid    = "Route53Read"
        Effect = "Allow"
        Action = [
          "route53:ListHostedZones"
        ]
        Resource = "*"
      },
      {
        Sid    = "ACMRead"
        Effect = "Allow"
        Action = [
          "acm:DescribeCertificate"
        ]
        Resource = "arn:aws:acm:eu-west-1:677276118863:certificate/*"
      },
      {
        Sid    = "ECRDescribeRepo"
        Effect = "Allow"
        Action = [
          "ecr:DescribeRepositories"
        ]
        Resource = aws_ecr_repository.flask_app.arn
      },
      {
        Sid    = "ECSDescribeCluster"
        Effect = "Allow"
        Action = [
          "ecs:DescribeClusters"
        ]
        Resource = "*"
      },
      {
        Sid    = "IAMReadProjectRoles"
        Effect = "Allow"
        Action = [
          "iam:GetRole"
        ]
        Resource = [
          aws_iam_role.ecs_task_execution_role.arn,
          aws_iam_role.ecs_task_role.arn
        ]
      },
      {
        Sid    = "IAMReadOIDCProvider"
        Effect = "Allow"
        Action = [
          "iam:GetOpenIDConnectProvider"
        ]
        Resource = aws_iam_openid_connect_provider.github.arn
      },
      {
        Sid    = "EC2ReadVpcAndEip"
        Effect = "Allow"
        Action = [
          "ec2:DescribeVpcs",
          "ec2:DescribeAddresses"
        ]
        Resource = "*"
      }
    ]
  })
}
