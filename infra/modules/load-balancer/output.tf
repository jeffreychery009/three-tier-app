output "target_group_arn" {
    description = "The ARN of the target group"
    value = aws_lb_target_group.main.arn
}

output "listener_arn" {
    description = "The ARN of the listener"
    value = aws_lb_listener.main.arn
}

output "load_balancer_arn" {
    description = "The ARN of the load balancer"
    value = aws_lb.main.arn
}