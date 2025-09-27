module "vpc" {
    source = "./modules/vpc"
    
    # VPC Configuration
    vpc_name = "three-tier-vpc"
    vpc_cidr_block = "10.0.0.0/16"
    vpc_tags = {
        Name = "three-tier-vpc"
        Environment = "production"
        Project = "three-tier-app"
    }
    
    # Availability Zones
    azs = ["us-east-1a", "us-east-1b"]
    
    # Public Subnets
    public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
    public_subnet_tags = {
        Name = "three-tier-public-subnet"
        Type = "public"
        Environment = "production"
    }
    public_subnet_name = "three-tier-public-subnet"
    
    # Private App Subnets
    private_app_subnet_name = "three-tier-private-app-subnet"
    private_app_subnet_cidrs = ["10.0.4.0/24", "10.0.5.0/24"]
    private_app_subnet_tags = {
        Name = "three-tier-private-app-subnet"
        Type = "private-app"
        Environment = "production"
    }
    
    # Private DB Subnets
    private_db_subnet_name = "three-tier-private-db-subnet"
    private_db_subnet_cidrs = ["10.0.7.0/24", "10.0.8.0/24"]
    private_db_subnet_tags = {
        Name = "three-tier-private-db-subnet"
        Type = "private-db"
        Environment = "production"
    }
    
    # Internet Gateway
    igw_name = "three-tier-igw"
}

# Output VPC information for use by other modules
output "vpc_id" {
    description = "ID of the VPC"
    value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
    description = "IDs of the public subnets"
    value       = module.vpc.public_subnet_ids
}

output "private_app_subnet_ids" {
    description = "IDs of the private app subnets"
    value       = module.vpc.private_app_subnet_ids
}

output "private_db_subnet_ids" {
    description = "IDs of the private DB subnets"
    value       = module.vpc.private_db_subnet_ids
}