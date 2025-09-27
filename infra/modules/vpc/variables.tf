# Variables for VPC
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
   
}

# Variables for Availability Zones
variable "azs" {
    type = list(string)
    description = "The availability zones of the VPC"
}

# Variables for IGW
variable "igw_name" {
    type = string
    description = "the name of the internet gateway"
}

# Variables for Public Subnet
variable "public_subnet_name" {
    type = string
    description = "the name of the public subnet"

}

variable "public_subnet_cidrs" {
    type = list(string)
    description = "The CIDR block of the public subnet"
}

variable "public_subnet_tags" {
    type = map(string)
    description = "The tags of the public subnet"
}

# Variables for Private App Subnet
variable "private_app_subnet_name" {
    type = string
    description = "the name of the private app subnet"
}

variable "private_app_subnet_cidrs" {
    type = list(string)
    description = "The CIDR block of the private app subnet"
}

variable "private_app_subnet_tags" {
    type = map(string)
    description = "The tags of the private app subnet"
}

# Variables for Private DB Subnet
variable "private_db_subnet_name" {
    type = string
    description = "the name of the private db subnet"
}

variable "private_db_subnet_cidrs" {
    type = list(string)
    description = "The CIDR block of the private db subnet"
}

variable "private_db_subnet_tags" {
    type = map(string)
    description = "The tags of the private db subnet"
}