terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.45"
    }
  }
}

data "aws_iam_policy_document" "cloudwatch_read_only" {
  statement {
    effect = "Allow"

    actions = [
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*"
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "cloudwatch_full_access" {
  statement {
    effect    = "Allow"
    actions   = ["cloudwatch:*"]
    resources = ["*"]
  }
}

resource "aws_iam_user" "example" {
  for_each = toset(var.user_names)

  name = each.key
}

resource "aws_iam_policy" "cloudwatch_read_only" {
  name   = "cloudwatch-read-only"
  policy = data.aws_iam_policy_document.cloudwatch_read_only.json
}

resource "aws_iam_policy" "cloudwatch_full_access" {
  name   = "cloudwatch-full-access"
  policy = data.aws_iam_policy_document.cloudwatch_full_access.json
}

resource "aws_iam_policy_attachment" "give_users_full" {
  count = var.give_users_full_cloudwatch_access ? 1 : 0

  name       = aws_iam_policy.cloudwatch_full_access.name
  users      = var.user_names
  policy_arn = aws_iam_policy.cloudwatch_full_access.arn
}

resource "aws_iam_policy_attachment" "give_users_read" {
  count = var.give_users_full_cloudwatch_access ? 0 : 1

  name       = aws_iam_policy.cloudwatch_read_only.name
  users      = var.user_names
  policy_arn = aws_iam_policy.cloudwatch_read_only.arn
}
