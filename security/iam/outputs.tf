output "all_users" {
  value       = aws_iam_user.example
  description = "The IAM users."
}

output "all_arns" {
  value       = values(aws_iam_user.example)[*].arn
  description = "The ARNs for all users."
}
