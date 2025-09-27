############################################
# VPC + 2 public, 2 private-app (with NAT per AZ), 2 private-db
############################################

locals {
  # Align subnets/azs by index key "0","1"
  az_map = { for i, az in var.azs :
    tostring(i) => {
      az  = az
      pub = var.public_subnet_cidrs[i]
      app = var.private_app_subnet_cidrs[i]
      db  = var.private_db_subnet_cidrs[i]
    }
  }
}

# Creating the VPC
resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr_block
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = var.vpc_name
    } 
}

# Creating Internet Gatewat for access to VPC from the internet
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = var.igw_name
    }
}

# Creating the public Subnets
resource "aws_subnet" "public_subnet" {
    for_each = local.az_map # for each availability zone

    vpc_id = aws_vpc.main.id
    cidr_block = each.value.pub
    availability_zone = each.value.az
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.public_subnet_name}-${each.value.az}"
    }
}

# Private App Subnets
resource "aws_subnet" "private_app" {
    for_each = local.az_map # for each availability zone
    
    vpc_id            = aws_vpc.main.id
    availability_zone = each.value.az
    cidr_block        = each.value.app
    
    tags = merge(var.private_app_subnet_tags, {
        Name = "${var.private_app_subnet_name}-${each.value.az}"
    })
}

# Private DB Subnets
resource "aws_subnet" "private_db" {
    for_each = local.az_map # for each availability zone
    
    vpc_id            = aws_vpc.main.id
    availability_zone = each.value.az
    cidr_block        = each.value.db
    
    tags = merge(var.private_db_subnet_tags, {
        Name = "${var.private_db_subnet_name}-${each.value.az}"
    })
}

# Creating the Public Route Table
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }
  tags = {
    Name = "${var.vpc_name}-public-route-table"
  }
}

# Associating the public route table with the public subnets
resource "aws_route_table_association" "public" {
    for_each = aws_subnet.public_subnet

    subnet_id = each.value.id
    route_table_id = aws_route_table.public.id
}

# Creating Elastic IPs for NAT Gateways
resource "aws_eip" "nat" {
    for_each = aws_subnet.public_subnet
    
    domain = "vpc"
    
    tags = {
        Name = "${var.vpc_name}-nat-eip-${each.value.availability_zone}"
    }
    
    depends_on = [aws_internet_gateway.main]
}

# Creating NAT Gateways in public subnets
resource "aws_nat_gateway" "main" {
    for_each = aws_subnet.public_subnet
    
    allocation_id = aws_eip.nat[each.key].id
    subnet_id     = each.value.id
    
    tags = {
        Name = "${var.vpc_name}-nat-gateway-${each.value.availability_zone}"
    }
    
    depends_on = [aws_internet_gateway.main]
}

# Creating private route table for App subnets
resource "aws_route_table" "private_app" {
    for_each = aws_subnet.public_subnet
    
    vpc_id = aws_vpc.main.id
    
    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.main[each.key].id
    }
    
    tags = {
        Name = "${var.vpc_name}-private-app-route-table-${each.value.availability_zone}"
    }
}

# Creating private route table for DB subnets (no internet access)
resource "aws_route_table" "private_db" {
    for_each = aws_subnet.private_db
    
    vpc_id = aws_vpc.main.id
    
    tags = {
        Name = "${var.vpc_name}-private-db-route-table-${each.value.availability_zone}"
    }
}

# Associating private app route table with private app subnets
resource "aws_route_table_association" "private_app" {
    for_each = aws_subnet.private_app
    
    subnet_id      = each.value.id
    route_table_id = aws_route_table.private_app[each.key].id
}

# Associating private db route table with private db subnets
resource "aws_route_table_association" "private_db" {
    for_each = aws_subnet.private_db
    
    subnet_id      = each.value.id
    route_table_id = aws_route_table.private_db[each.key].id
}