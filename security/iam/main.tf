terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.45"
    }
  }
}

resource "aws_iam_user" "example" {
  count = length(var.user_names)

  name = var.user_names[count.index]
}
