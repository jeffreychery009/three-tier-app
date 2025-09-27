# VPC Outputs
output "vpc_id" {
    description = "ID of the VPC"
    value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
    description = "CIDR block of the VPC"
    value       = aws_vpc.main.cidr_block
}

# Internet Gateway Output
output "internet_gateway_id" {
    description = "ID of the Internet Gateway"
    value       = aws_internet_gateway.main.id
}

# Public Subnet Outputs
output "public_subnet_ids" {
    description = "List of IDs of the public subnets"
    value       = [for subnet in aws_subnet.public_subnet : subnet.id]
}

output "public_subnet_cidrs" {
    description = "List of CIDR blocks of the public subnets"
    value       = [for subnet in aws_subnet.public_subnet : subnet.cidr_block]
}

# Private App Subnet Outputs
output "private_app_subnet_ids" {
    description = "List of IDs of the private app subnets"
    value       = [for subnet in aws_subnet.private_app : subnet.id]
}

output "private_app_subnet_cidrs" {
    description = "List of CIDR blocks of the private app subnets"
    value       = [for subnet in aws_subnet.private_app : subnet.cidr_block]
}

# Private DB Subnet Outputs
output "private_db_subnet_ids" {
    description = "List of IDs of the private DB subnets"
    value       = [for subnet in aws_subnet.private_db : subnet.id]
}

output "private_db_subnet_cidrs" {
    description = "List of CIDR blocks of the private DB subnets"
    value       = [for subnet in aws_subnet.private_db : subnet.cidr_block]
}

# NAT Gateway Outputs
output "nat_gateway_ids" {
    description = "List of IDs of the NAT Gateways"
    value       = [for nat in aws_nat_gateway.main : nat.id]
}

# Route Table Outputs
output "public_route_table_id" {
    description = "ID of the public route table"
    value       = aws_route_table.public.id
}

output "private_app_route_table_ids" {
    description = "List of IDs of the private app route tables"
    value       = [for rt in aws_route_table.private_app : rt.id]
}

output "private_db_route_table_ids" {
    description = "List of IDs of the private DB route tables"
    value       = [for rt in aws_route_table.private_db : rt.id]
}
