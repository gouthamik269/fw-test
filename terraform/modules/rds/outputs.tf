output "db_instance_endpoint" {
  value       = aws_db_instance.postgresql.endpoint
  description = "Connect endpoint for the DB"
}

output "db_instance_identifier" {
  value       = aws_db_instance.postgresql.id
}

output "db_instance_arn" {
  value       = aws_db_instance.postgresql.arn
}

output "vpc_security_group_ids" {
  value = aws_security_group.rds.id
}