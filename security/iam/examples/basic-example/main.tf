provider "aws" {
  region = "us-east-1"
}

module "iam_users" {
  source = "../../"

  user_names = ["elayne", "terralearning"]
}
