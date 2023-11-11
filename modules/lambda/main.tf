module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = var.function_name
  description   = var.description
  handler       = var.handler
  runtime       = var.runtime
  publish       = true

  source_path = var.source_path

  store_on_s3 = true
  s3_bucket   = var.s3_bucket

  environment_variables = {
    Serverless = "Terraform"
  }
}

resource "aws_lambda_function" "lambda_function" {
  code_signing_config_arn = ""
  description             = ""
  filename                = var.source_path
  function_name           = "${var.function_name}-lambda-function"
  role                    = aws_iam_role.iam_role.arn
  handler                 = var.handler
  runtime                 = var.runtime
  vpc_config {
    subnet_ids = var.public_subnets
    security_group_ids = [aws_security_group.lambda_sg.id]
  }
}


resource "aws_security_group" "lambda_sg" {
  name = "lambda_sg"
  vpc_id = var.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

data "aws_iam_policy_document" "AWSLambdaTrustPolicy" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "VPCAccessPolicy" {
  version = "2012-10-17"
  statement {
    actions = [
      "ec2:DescribeNetworkInterfaces",
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeInstances",
      "ec2:AttachNetworkInterface"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "vpc_access_policy" {
  name        = "${var.function_name}-vpc-access-policy"
  description = "Policy for allowing Lambda to access VPC resources"
  policy      = data.aws_iam_policy_document.VPCAccessPolicy.json
}

resource "aws_iam_role" "iam_role" {
  assume_role_policy = data.aws_iam_policy_document.AWSLambdaTrustPolicy.json
  name               = "${var.function_name}-iam-role-lambda-trigger"
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_lambda_basic_execution" {
  role       = aws_iam_role.iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_vpc_access" {
  role       = aws_iam_role.iam_role.name
  policy_arn = aws_iam_policy.vpc_access_policy.arn
}