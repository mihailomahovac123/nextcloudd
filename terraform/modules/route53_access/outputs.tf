output "route53_access_role_id" {
  description = "ID of a role that can access Route 53."
  value = aws_iam_role.route53-role.id
}

output "route53_access_role_name" {
  description = "Name of the role that can access Route 53."
  value = aws_iam_role.route53-role.name
}