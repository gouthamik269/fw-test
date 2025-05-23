output "db_instance_endpoint" {
  value       = aws_db_instance.this.endpoint
  description = "Connect endpoint for the DB"
}

output "db_instance_identifier" {
  value       = aws_db_instance.this.id
}

output "db_instance_arn" {
  value       = aws_db_instance.this.arn
}

output "vpc_security_group_ids" {
  value = aws_security_group.rds.id
}