# Look up the existing Jenkins VPC by Name tag
data "aws_vpc" "jenkins" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

# Look up existing public subnet A by Name tag and scope to that VPC
data "aws_subnet" "public_a" {
  filter {
    name   = "tag:Name"
    values = [var.public_subnet_a_name]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.jenkins.id]
  }
}

# Get the route table currently associated to subnet A 
data "aws_route_table" "public_rt_for_a" {
  subnet_id = data.aws_subnet.public_a.id
}

# Create NEW public subnet B in the same VPC
resource "aws_subnet" "public_b" {
  vpc_id                  = data.aws_vpc.jenkins.id
  cidr_block              = var.public_b_cidr
  availability_zone       = var.public_b_az
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_subnet_b_name
  }
}

# Associate subnet B to the *same* public route table as subnet A
resource "aws_route_table_association" "public_b_assoc" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = data.aws_route_table.public_rt_for_a.id
}

# Convenience local: pass these to your ASG's vpc_zone_identifier
locals {
  asg_subnet_ids = [
    data.aws_subnet.public_a.id,
    aws_subnet.public_b.id,
  ]
}
