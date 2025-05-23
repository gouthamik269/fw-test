/*
  Output variables needed
*/
output "private_subnet_1a_id" {
  description = "ID of private subnet 1a"
  value       = aws_subnet.private-subnet-1a.id
}

output "private_subnet_1b_id" {
  description = "ID of private subnet 1b"
  value       = aws_subnet.private-subnet-1b.id
}

output "private_subnet_1c_id" {
  description = "ID of private subnet 1c"
  value       = aws_subnet.private-subnet-1c.id
}

output "public_subnet_1a_id" {
  description = "ID of public subnet 1a"
  value       = aws_subnet.public-subnet-1a.id
}

output "public_subnet_1b_id" {
  description = "ID of public subnet 1b"
  value       = aws_subnet.public-subnet-1b.id
}

output "public_subnet_1c_id" {
  description = "ID of public subnet 1c"
  value       = aws_subnet.public_subnet_1c.id
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.fw_vpc.id
}

output "internet_gateway" {
  description = "ID of the internet gateway"
  value       = aws_internet_gateway.internet-gw.id
}

output "private_route_table_1a_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private_route_table_1a.id
}
output "private_route_table_1b_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private_route_table_1b.id
}
output "private_route_table_1c_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private_route_table_1c.id
}

output "public_route_table_id_1a" {
  description = "ID of the public route table"
  value       = aws_route_table.public_route_table_1a.id
}

output "public_route_table_id_1b" {
  description = "ID of the public route table"
  value       = aws_route_table.public_route_table_1b.id
}

output "public_route_table_id_1c" {
  description = "ID of the public route table"
  value       = aws_route_table.public_route_table_1c.id
}
