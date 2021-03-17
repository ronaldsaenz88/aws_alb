variable "aws_region" {}
variable "aws_az1" {}
variable "aws_az2" {}
variable "aws_profile" {}
variable "vpc_cidr" {}
variable "sub_private1_cidr" {}
variable "sub_private2_cidr" {}
variable "sub_public1_cidr" {}
variable "sub_public2_cidr" {}
variable "instance_type" {}
variable "my_ssh_key_name" {}

variable "boot_image" {
  description = "The Boot Image"
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
}

variable "boot_canonical" {
  description = "The Boot Canonical Image"
  type        = string
  default     = "099720109477"
}

variable "virtualization_type" {
  description = "Virtualization Type of EC2 AWS."
  type        = string
  default     = "hvm"
}

variable "tags_name" {
  description = "Tag Name."
  type        = string
  default     = "Flugel"
}

variable "tags_owner" {
  description = "Tag Owner."
  type        = string
  default     = "InfraTeam"
}