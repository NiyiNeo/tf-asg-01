variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

#Ecom User for Auto Scaling Group
variable "aws_profile" {
  description = "The aws profile for this project"
  type        = string
  default     = "tf.admin"
}

variable "key_name" {
  description = "Key value for the EC2 instance"
  type        = string
  default     = "tf-admin-key"
}


#EC2 Instance Details
variable "ami_id" {
  description = "AMI of the EC2 instance" #Ubuntu
  type        = string
  default     = "ami-0a7d80731ae1b2435"
}

variable "instance_type" {
  description = "Type of EC2 Instance"
  type        = string
  default     = "t3.micro"
}


#VPC Setup
variable "vpc_name" {
  description = "The default VPC for Auto Scaling Group"
  type        = string
  default     = "jenkins-vpc"
}

variable "public_subnet_a_name" {
  description = "The first public subnet, already exist "
  type        = string
  default     = "jenkins-public-jsn"
}

variable "public_subnet_b_name" {
  description = "The second public subnet, new subnet "
  type        = string
  default     = "jenkins-public-jsn-b"
}

variable "public_b_cidr" {
  description = "Addning a second subnet to VPC, (non-overlapping)"
  type        = string
  default     = "10.0.12.0/24"
}

variable "public_b_az" {
  description = "AZ for subnet b "
  type        = string
  default     = "us-east-1b"
}

#Security Group CIDRs
variable "ssh_cidr" {
  description = "Secure access to EC2"
  type        = string
  default     = "75.73.183.9/32"
}

variable "http_cidrs" {
  description = "CIDR blocks allowed to HTTP (80)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "https_cidrs" {
  description = "CIDR blocks allowed to HTTPS (443)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

#Auto Scaling Sizes
variable "asg_min" {
  description = "Minimum capacity of EC2 instances for ASG"
  type        = number
  default     = 2
}

variable "asg_desired" {
  description = "Desired capacity of EC2 instances for ASG"
  type        = number
  default     = 2
}

variable "asg_max" {
  description = "Maximum capacity of EC2 instances for ASG"
  type        = number
  default     = 5
}

#Tags
variable "app_name" {
  description = "Apache Web Server"
  type        = string
  default     = "apache-asg"
}

