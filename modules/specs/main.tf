module "vm_test" {
  source              = "../../../"
  boot_canonical      = "099720109477"
  boot_image          = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
  virtualization_type = "hvm"
  instance_type       = "t2.micro"
  project_name        = "terraform_admin"
  aws_profile         = "default"
  aws_region          = "us-east-1"
  aws_az1             = "us-east-1a"
  aws_az2             = "us-east-1b"
  vpc_cidr            = "192.168.200.0/23"
  sub_public1_cidr    = "192.168.200.0/25"
  sub_public2_cidr    = "192.168.200.128/25"
  sub_private1_cidr   = "192.168.201.0/25"
  sub_private2_cidr   = "192.168.201.128/25"
  tags_name           = "Flugel"
  tags_owner          = "InfraTeam"
  my_ssh_key_name     = "my_ssh_web"
}



