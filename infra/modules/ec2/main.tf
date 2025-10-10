data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}


resource "aws_security_group" "ec2_sg" {
    name_prefix = "${var.ec2_name}-sg"
    vpc_id = var.vpc_id

    # Allow HTTP traffic
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = var.allowed_cidr_blocks
    }

    # Allow HTTPS traffic
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = var.allowed_cidr_blocks
    }

    # Allow SSH traffic (won't be used in production)
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = var.allowed_cidr_blocks
    }

    # Allow all outbound traffic
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "${var.ec2_name}-sg"
    }
}

resource "aws_instance" "main" {
    count = var.ec2_count



    ami = data.aws_ami.ubuntu.id
    subnet_id = var.subnet_ids[count.index]
    instance_type = var.ec2_instance_type
    vpc_security_group_ids = [aws_security_group.ec2_sg.id]

    tags = {
        Name = "${var.ec2_name}-${count.index + 1}"
        Subnet = var.subnet_ids[count.index]
    }
}

resource "aws_lb_target_group_attachment" "main" {
    count = var.ec2_count
    target_group_arn = var.target_group_arn
    target_id = aws_instance.main[count.index].id
    port = 80
  
}