
# Security Group for ASG instances
resource "aws_security_group" "web_sg" {
  name        = "${var.app_name}-sg"
  description = "Allow HTTP/HTTPS from the Internet and SSH from my IP"
  vpc_id      = data.aws_vpc.jenkins.id

  # outbound anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP 80 from Internet
  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.http_cidrs
  }

  # HTTPS 443 from Internet 
  ingress {
    description = "HTTPS from Internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.https_cidrs
  }

  # SSH for admin profile
  ingress {
    description = "SSH from admin IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  tags = {
    Name = "${var.app_name}-sg"
  }
}


# Launch Template (Ubuntu + Apache user_data)
resource "aws_launch_template" "web" {
  name_prefix   = "${var.app_name}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name


  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.web_sg.id]
  }

  # User data installs Apache and serves a simple page
  user_data = base64encode(file("${path.module}/user_data_apache.sh"))

  update_default_version = true

  # tag EC2 instances launched by this template
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.app_name
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}


# Auto Scaling Group
resource "aws_autoscaling_group" "web" {
  name             = "${var.app_name}-asg"
  min_size         = var.asg_min
  desired_capacity = var.asg_desired
  max_size         = var.asg_max

  # Use the two subnets (A from data source, B created earlier)
  vpc_zone_identifier       = local.asg_subnet_ids
  health_check_type         = "EC2"
  health_check_grace_period = 120
  capacity_rebalance        = true

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = var.app_name
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

terraform {
  backend "s3" {}
}