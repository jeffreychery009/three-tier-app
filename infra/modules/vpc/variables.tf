variable "vpc_name" {
    type = string
    description = "The name of the VPC"
}

variable "vpc_cidr_block" {
    type = string
    description = "The CIDR block of the VPC"
}

variable "vpc_tags" {
    type = map(string)
    description = "The tags of the VPC"
    default = {
        Name = var.vpc_name
    }
}