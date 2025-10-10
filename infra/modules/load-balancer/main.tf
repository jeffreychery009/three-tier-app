resource "aws_security_group" "load_balancer_sg" {
  name = "${var.load_balancer_name}-sg"
  vpc_id = var.vpc_id

  # Allow HTTP traffic from the internet
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP traffic from the internet
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.load_balancer_name}-sg"
  }
  
}

resource "aws_lb" "main" {
  name = var.load_balancer_name
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.load_balancer_sg.id]
  subnets = var.load_balancer_subnets

  tags = {
    Name = var.load_balancer_name
  }
}

# Defining the target group
resource "aws_lb_target_group" "main" {
  name = var.target_group_name
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id

  # Defining the health check
  health_check {
    enabled = true
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    path = "/"
    port = "traffic-port"
    protocol = "HTTP"
    matcher = "200-302"
  }

  tags = {
    Name = var.target_group_name
  }
}

# Defining the listener
resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
  tags = {
    Name = var.load_balancer_name
  }
}