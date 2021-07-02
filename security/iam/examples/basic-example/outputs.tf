output "all_users" {
  value       = module.iam_users.all_users
  description = "All IAM users."
}

output "all_arns" {
  value       = module.iam_users.all_arns
  description = "The ARNs for all users."
}
