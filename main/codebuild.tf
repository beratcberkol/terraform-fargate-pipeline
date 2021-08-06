#Terraform file for codebuild project. It will use buildspec.yml file located in the root directory.

resource "aws_iam_role" "codebuild_role" {
  name = "code-build-${var.app}-service-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "codebuild-role-policy" {
  name = "code-build-role-policy"
  role = "${aws_iam_role.codebuild_role.name}"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "application-autoscaling:RegisterScalableTarget",
        "application-autoscaling:DeregisterScalableTarget"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecs:UpdateService"
      ],
      "Resource": "arn:aws:ecs:eu-west-1:744731213525:service/simple-react-app-development/simple-react-app-development"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketAcl",
        "s3:GetBucketLocation"
      ],
      "Resource": "arn:aws:s3:::sample-react-app-pipeline-bucket/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:CreateLogGroup",
        "logs:PutLogEvents"
      ],
      "Resource":[ 
          "arn:aws:logs:eu-west-1:744731213525:log-group:/aws/codebuild/sample-react-app",
          "arn:aws:logs:eu-west-1:744731213525:log-group:/aws/codebuild/sample-react-app:log-stream:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:CompleteLayerUpload",
        "ecr:InitiateLayerUpload",
        "ecr:PutImage",
        "ecr:UploadLayerPart"
      ],
      "Resource": "arn:aws:ecr:*:744731213525:repository/sample-react-app"
    }
  ]
}
POLICY
}
#Inline Policy for AWS CodeBuild Project IAM Role

data "template_file" "buildspec" {
  template = "${file("buildspec.yml")}"
}

resource "aws_codebuild_project" "sample-react-app-build" {
  badge_enabled  = false
  build_timeout  = 60
  name           = var.app
  queued_timeout = 480
  service_role   = aws_iam_role.codebuild_role.arn
  artifacts {
    encryption_disabled    = false
    name                   = var.app
    override_artifact_name = false
    packaging              = "NONE"
    type                   = "CODEPIPELINE"
  }
#privileged_mode is on because this codebuild project will create a docker image and push the image with the "latest" tag.(configured in buildspec.yml)
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    type                        = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

  source {
    buildspec           = data.template_file.buildspec.rendered
    git_clone_depth     = 0
    insecure_ssl        = false
    report_build_status = false
    type                = "CODEPIPELINE"
  }
}