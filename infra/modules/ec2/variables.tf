variable "ec2_name" {
    type = string
    description = "The name of the EC2 instance"
}

variable "ec2_instance_type" {
    type = string
    description = "The instance type of the EC2 instance"
    default = "t2.micro"
}

variable "ec2_tags" {
    type = map(string)
    description = "The tags of the EC2 instance"
}

variable "subnet_ids" {
  type        = list(string)
  description = "ID of the subnet to launch the instance in"
}

variable "ec2_count" {
    type = number
    description = "The count of the EC2 instance"
    default = 2
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC"
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks allowed to access the instance"
  default     = ["10.0.0.0/16"]  # Allow access from your VPC
}
