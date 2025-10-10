variable "vpc_id" {
    type = string
    description = "The ID of the VPC"
}

variable "load_balancer_name" {
    type = string
    description = "The name of the load balancer"
}

variable "load_balancer_tags" {
    type = map(string)
    description = "The tags of the load balancer"
}

variable "load_balancer_subnets" {
    type = list(string)
    description = "The subnets of the load balancer"
}

variable "target_group_name" {
    type = string
    description = "The name of the load balancer target group"
}