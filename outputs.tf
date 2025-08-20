# Networking Ouputs
output "vpc_id" {
  value       = data.aws_vpc.jenkins.id
  description = "VPC used for stack"
}

output "public_subnet_a_id" {
  value       = data.aws_subnet.public_a.id
  description = "Existing public subnet A"
}

output "public_subnet_b_id" {
  value       = aws_subnet.public_b.id
  description = "New public subnet B"
}

output "subnet_a_az" {
  value       = data.aws_subnet.public_a.availability_zone
  description = "AZ of subnet A"
}

output "subnet_b_az" {
  value       = aws_subnet.public_b.availability_zone
  description = "AZ of subnet B"
}

output "public_route_table_id" {
  value       = data.aws_route_table.public_rt_for_a.id
  description = "Public route table (0.0.0.0/0 -> IGW)"
}

output "asg_subnet_ids" {
  value       = local.asg_subnet_ids
  description = "Subnets the ASG spans (2 subnets)"
}

# Security Group Outputs
output "instance_security_group_id" {
  value       = aws_security_group.web_sg.id
  description = "Security group applied to ASG instances"
}

# Launch Template & ASG Outputs
output "launch_template_id" {
  value       = aws_launch_template.web.id
  description = "Launch Template ID used by the ASG"
}

output "asg_name" {
  value       = aws_autoscaling_group.web.name
  description = "Auto Scaling Group name"
}

output "asg_arn" {
  value       = aws_autoscaling_group.web.arn
  description = "Auto Scaling Group ARN"
}

output "asg_capacity" {
  value = {
    min     = aws_autoscaling_group.web.min_size
    desired = aws_autoscaling_group.web.desired_capacity
    max     = aws_autoscaling_group.web.max_size
  }
  description = "ASG capacity settings"
}
