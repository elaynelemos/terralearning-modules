output "all_users" {
  value       = aws_iam_user.example
  description = "The IAM users."
}

output "all_arns" {
  value       = values(aws_iam_user.example)[*].arn
  description = "The ARNs for all users."
}

output "upper_names" {
  value       = [for name in var.user_names: upper(name)]
  description = "The user names uppercased."
}

output "short_upper_names" {
  value       = [for name in var.user_names: upper(name) if length(name) < 7]
  description = "The user names uppercased."
}
