output "db_host" {
  description = "value"
  value       = "mongodb://${aws_instance.ec2_mongodb_instance.private_ip}:27017/posts"
}

# output "mongodb_private_ip" {
#   description = "value"
#   value = aws_instance.ec2_mongodb_instance.private_ip
# }

output "github_token" {
  description = "value"
  value = var.github_token
  sensitive = true
}