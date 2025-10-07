output "ec2_ids" {
    description = "IDs of the EC2 instances"
    value = { for k, v in aws_instance.main : k => v.id }
}

output "ec2_instance_types" {
    description = "Instance types of the EC2 instances"
    value = { for k, v in aws_instance.main : k => v.instance_type }
}

output "ec2_private_ips" {
    description = "Private IP addresses of the EC2 instances"
    value = { for k, v in aws_instance.main : k => v.private_ip }
}

output "ec2_subnet_ids" {
    description = "Subnet IDs where instances are deployed"
    value = { for k, v in aws_instance.main : k => v.subnet_id }
}

output "ec2_security_group_ids" {
    description = "ID of the EC2 security group"
    value = aws_security_group.ec2_sg.id
}