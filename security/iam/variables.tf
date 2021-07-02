variable "user_names" {
  description = "Create IAM users with these names."
  type        = list(string)
}

variable "give_users_full_cloudwatch_access" {
  description = "If true, the users get full access to CloudWatch."
  type        = bool
}
