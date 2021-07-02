provider "aws" {
  region = "us-east-1"
}

module "iam_users" {
  source = "../../"

  user_names = ["elayne", "terralearning"]

  give_users_full_cloudwatch_access = false
}
