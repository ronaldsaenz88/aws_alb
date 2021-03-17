#Configuration a new VPC with only one public subnet.
#Configuration a cluster (deployed in a new VPC) of 2 EC2 instances behind an ALB.
#Configuration EC2 Instance in AWS
#Configuration ALB running NGINX, serving a static file.
#This static file must be generate at boot, using a Python script. Put the AWS instance tags in the file.

#__author__ = "Ronald Saenz"
#__status__ = "Development"
#__copyright__ = "Copyright 2021, RSAENZ"
#__maintainer__ = "Ronald Saenz"
#__email__ = "ronaldsaenz88@gmail.com"
#__version__ = "0.0.4"
# https://blog.andreev.it/?p=6372

terraform {
  backend "remote" {
    # The name of your Terraform Cloud organization.
    organization = "RonaldSaenz-AWS"

    # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
      name = "aws_alb"
    }
  }
}

/*************** AWS ***************/
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  access_key = "AKIA4BGY64GLI27MUQLG"
  secret_key = "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"
}

/*************** VPC ***************/
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = "${var.tags_name} - MY VPC"
    Owner       = var.tags_owner
    Description = "MY VPC"
  }
}

/*************** SUBNETS ***************/
# Public subnet 1
resource "aws_subnet" "subnet_public_1" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.sub_public1_cidr
  availability_zone = var.aws_az1

  tags = {
    Name        = "${var.tags_name} - PUBLIC SUBNET 1"
    Owner       = var.tags_owner
    Description = "PUBLIC SUBNET 1"
  }
}

# Public subnet 2
resource "aws_subnet" "subnet_public_2" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.sub_public2_cidr
  availability_zone = var.aws_az2

  tags = {
    Name        = "${var.tags_name} - PUBLIC SUBNET 2"
    Owner       = var.tags_owner
    Description = "PUBLIC SUBNET 2"
  }
}

# Private subnet 1
resource "aws_subnet" "subnet_private_1" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.sub_private1_cidr
  availability_zone = var.aws_az1

  tags = {
    Name        = "${var.tags_name} - PRIVATE SUBNET 1"
    Owner       = var.tags_owner
    Description = "PRIVATE SUBNET 1"
  }
}

# Private subnet 2
resource "aws_subnet" "subnet_private_2" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.sub_private2_cidr
  availability_zone = var.aws_az2

  tags = {
    Name        = "${var.tags_name} - PRIVATE SUBNET 2"
    Owner       = var.tags_owner
    Description = "PRIVATE SUBNET 2"
  }
}

# Internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name        = "${var.tags_name} - My Internet GW"
    Owner       = var.tags_owner
    Description = "Internet GW"
  }
}


/*************** SECURITY GROUPS - TRAFFIC ALLOWED ***************/
# Security group for bastion host
resource "aws_security_group" "secgroup_web_master" {
  name = "${var.tags_name} - Web Master - Allow Port 22 and 80"
  description = "Allow access on port 22 and 80 from everywhere"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.tags_name} - Web Master - Allow Port 22 and 80"
    Owner       = var.tags_owner
    Description = "Allow access on port 22 and 80 from everywhere"
  }
}

# Security group for application load balancer
resource "aws_security_group" "secgroup_alb" {
  name = "${var.tags_name} - ALB - Allow Port 80"
  description = "Allow access on port 80 from everywhere"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.tags_name} - ALB - Allow Port 80"
    Owner       = var.tags_owner
    Description = "Allow access on port 80 HTTP from everywhere"
  }
}

# Security group for application hosts
resource "aws_security_group" "secgroup_webs" {
  name = "${var.tags_name} - WEBs - Allow Port 22 and 80"
  description = "Allow access on port 22 and 80"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.tags_name} - WEBs - Allow Port 22 and 80"
    Owner       = var.tags_owner
    Description = "Allow access on port 22 and 80"
  }
}


/*************** EC2 INSTANCES ***************/
#prepare Data of Instance EC2 on AWS
data "aws_ami" "image_ec2" {
  most_recent = true

  filter {
    name = "name"
    values = [var.boot_image]
  }

  filter {
    name = "virtualization-type"
    values = [var.virtualization_type]
  }

  owners = [var.boot_canonical] #Canonical
}

# ec2 instance - bastion host
resource "aws_instance" "ec2_web_master" {
  ami = data.aws_ami.image_ec2.id
  instance_type = var.instance_type
  key_name = "${var.my_ssh_key_name}"
  vpc_security_group_ids = [aws_security_group.secgroup_web_master.id]
  subnet_id = aws_subnet.subnet_public_1.id
  associate_public_ip_address = true

  depends_on = [aws_instance.ec2_web_1, aws_instance.ec2_web_2]

  user_data              = "${data.template_file.init_web_master.rendered}"

  provisioner "file" {
    source      = "${var.my_ssh_key_name}.pem"
    destination = "/home/ubuntu/${var.my_ssh_key_name}.pem"

    connection {
      type          = "ssh"
      host          = "${aws_instance.ec2_web_master.public_ip}"
      port          = 22
      user          = "ubuntu"
      password      = ""
      timeout       = "1m"
      private_key   = "${file("${var.my_ssh_key_name}.pem")}"
      agent         = false
    }
  }

  root_block_device {
    delete_on_termination = true
  }

  tags = {
    Name        = "${var.tags_name} - WEB MASTER"
    Owner       = var.tags_owner
    Description = "Web Server Master - Instance EC2"
  }
}

data "template_file" "init_web_master" {
  template = "${file("userdata_web_master.tpl")}"

  vars = {
    ssh_key_name = var.my_ssh_key_name
    aws_web_1 = aws_instance.ec2_web_1.private_ip
    aws_web_1_tags_name = aws_instance.ec2_web_1.tags.Name
    aws_web_1_tags_owner = aws_instance.ec2_web_1.tags.Owner
    aws_web_1_tags_description = aws_instance.ec2_web_1.tags.Description
    aws_web_2 = aws_instance.ec2_web_2.private_ip
    aws_web_2_tags_name = aws_instance.ec2_web_2.tags.Name
    aws_web_2_tags_owner = aws_instance.ec2_web_2.tags.Owner
    aws_web_2_tags_description = aws_instance.ec2_web_2.tags.Description
  }
}

data "template_file" "init_web_1" {
  template = "${file("userdata_web_1.tpl")}"
}

data "template_file" "init_web_2" {
  template = "${file("userdata_web_2.tpl")}"
}

# ec2 instance - app host 1
resource "aws_instance" "ec2_web_1" {
  ami = data.aws_ami.image_ec2.id
  instance_type = var.instance_type
  key_name = "${var.my_ssh_key_name}"
  vpc_security_group_ids = [aws_security_group.secgroup_webs.id]
  subnet_id = aws_subnet.subnet_private_1.id
  associate_public_ip_address = false

  user_data              = "${data.template_file.init_web_1.rendered}"

  root_block_device {
    delete_on_termination = true
  }

  tags = {
    Name        = "${var.tags_name} - WEB SERVER #1"
    Owner       = var.tags_owner
    Description = "Web Server #1 - Instance EC2"
  }
}

# ec2 instance - app host 2
resource "aws_instance" "ec2_web_2" {
  ami = data.aws_ami.image_ec2.id
  instance_type = var.instance_type
  key_name = "${var.my_ssh_key_name}"
  vpc_security_group_ids = [aws_security_group.secgroup_webs.id]
  subnet_id = aws_subnet.subnet_private_2.id
  associate_public_ip_address = false

  user_data              = "${data.template_file.init_web_2.rendered}"

  root_block_device {
    delete_on_termination = true
  }

  tags = {
    Name        = "${var.tags_name} - WEB SERVER #2"
    Owner       = var.tags_owner
    Description = "Web Server #2 - Instance EC2"
  }
}


/*************** IPS AND ROUTES ***************/
# Elastic IP for the NAT gateway
resource "aws_eip" "my_eip" {
  vpc = true

  tags = {
    Name        = "${var.tags_name} - MY EIP"
    Owner       = var.tags_owner
    Description = "MY ELASTIC IP"
  }
}

# NAT gateway
resource "aws_nat_gateway" "my_nat_gw" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.subnet_public_1.id

  tags = {
    Name        = "${var.tags_name} - MY NAT GW"
    Owner       = var.tags_owner
    Description = "MY NAT GATEWAY"
  }
}

# Add route to Internet to main route table
resource "aws_route" "route_main" {
  route_table_id = aws_vpc.my_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.my_nat_gw.id
}

# Create public route table
resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name        = "${var.tags_name} - ROUTE PUBLIC"
    Owner       = var.tags_owner
    Description = "ROUTE PUBLIC"
  }
}

# Add route to Internet to public route table
resource "aws_route" "route_public" {
  route_table_id = aws_route_table.route_table_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.my_igw.id
}

# Associate public route table with public subnet 1
resource "aws_route_table_association" "route_table_assoc_public_1" {
  subnet_id   = aws_subnet.subnet_public_1.id
  route_table_id = aws_route_table.route_table_public.id
}

# Associate public route table with public subnet 2
resource "aws_route_table_association" "route_table_assoc_public_2" {
  subnet_id   = aws_subnet.subnet_public_2.id
  route_table_id = aws_route_table.route_table_public.id
}

/*************** ALB - LOAD BALANCER ***************/
# Application Load Balancer
resource "aws_lb" "my_alb" {
  name               = "${var.tags_name}ALB"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.subnet_public_1.id, aws_subnet.subnet_public_2.id]
  security_groups = [aws_security_group.secgroup_alb.id]
}

# Target group
resource "aws_lb_target_group" "my_alb_target_group" {
  name = "${var.tags_name}ALBTargetGroup"
  port = "80"
  protocol = "HTTP"
  vpc_id = aws_vpc.my_vpc.id

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    path                = "/index.html"
    port 				= 80
    matcher 			= "200"
    interval            = 30
  }

  tags = {
    Name        = "${var.tags_name}ALBTargetGroup"
    Owner       = var.tags_owner
    Description = "Application Load Balancer - Target Group"
  }
}

# Listener
resource "aws_lb_listener" "my_alb_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.my_alb_target_group.arn
  }
}

# Add instance 1 to target group
resource "aws_lb_target_group_attachment" "my_alb_target_group_att_1" {
  target_group_arn = aws_lb_target_group.my_alb_target_group.arn
  target_id        = aws_instance.ec2_web_1.id
  port             = "80"
}

# Add instance 2 to target group
resource "aws_lb_target_group_attachment" "my_alb_target_group_att_2" {
  target_group_arn = aws_lb_target_group.my_alb_target_group.arn
  target_id        = aws_instance.ec2_web_2.id
  port             = "80"
}
