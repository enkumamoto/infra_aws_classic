### S3 Bucket Policy ###
resource "aws_s3_bucket_policy" "load-balancer-logs-policy" {
  bucket = aws_s3_bucket.load-balancer-logs-bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowELBAccess"
        Effect = "Allow"
        Principal = {
          Service = ["elb.amazonaws.com", "elb.amazonaws.com.cn"]
        }
        Action = [
          "s3:GetBucketLocation",
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = [
          aws_s3_bucket.load-balancer-logs-bucket.arn,
          "${aws_s3_bucket.load-balancer-logs-bucket.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Principal = {
          Service = "elasticloadbalancing.amazonaws.com"
        }
        Action   = "s3:GetBucketLocation"
        Resource = aws_s3_bucket.load-balancer-logs-bucket.arn
      }
    ]
  })
}

### ECS Cluster Policy ###
resource "aws_iam_policy" "ecs_task_policy" {
  name        = "ecs-task-policy-${var.environment}"
  description = "Policy for ECS tasks"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:AttachNetworkInterface",
          "ec2:DetachNetworkInterface",
          "ec2:DescribeSubnets",
          "elasticfilesystem:ClientMount",
          "elasticfilesystem:ClientWrite",
          "elasticfilesystem:ClientRead"
        ]
        Resource = "*"
      },
      # Adicione outras permissões conforme necessário
    ]
  })
}

resource "aws_iam_policy" "ecs_cluster_policy" {
  name        = "ecs-cluster-policy-${var.environment}"
  description = "Policy for ECS clusters"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecs:CreateCluster",
          "ecs:ListClusters",
          "ecs:ListContainerInstances",
          "ecs:ListServices",
          "ecs:ListTaskDefinitions",
          "ecs:StartTeardowm",
          "ecs:StopTeardown",
          "ecs:UpdateService",
          "ecs:RunTask",
          "ecs:DescribeTasks",
          "ecs:DescribeContainerInstances",
          "ecs:PutClusterCapacityProviders",
          "ecs:GetCapacityProvisioners",
          "cloudwatch:PutMetricData",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },
      # Adicione outras permissões conforme necessário
    ]
  })
}
