# aws_alb
Project AWS - AWS LOAD BALANCER WITH 2  EC2 INSTANCES

## Usage

Before executing you must configure the environment variables:

Linux:
```bash
$ export AWS_ACCESS_KEY_ID="XXXXXXXXXXXX"
$ export AWS_SECRET_ACCESS_KEY="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
```

Windows:
```
set AWS_ACCESS_KEY_ID="XXXXXXXXXXXX"
set AWS_SECRET_ACCESS_KEY="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
```

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply 
```

If you want to change the variables, you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply -var="aws_region=us-east-1" -var="instance_type=t2.micro" -var="boot_image=ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*" -var="boot_canonical=099720109477" -var="tags_name=Flugel" -var="tags_owner=InfraTeam"
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

## Examples

* [Basic EC2 instance](https://github.com/terraform-aws-modules/terraform-aws-ec2-instance/tree/master/examples/basic)
* [Complete ALB](https://github.com/terraform-aws-modules/terraform-aws-alb/tree/master/examples/complete-alb)
* [Deploy nginx HA cluster](https://blog.andreev.it/?p=6372)
* [EC2 instance with EBS volume attachment](https://github.com/terraform-aws-modules/terraform-aws-ec2-instance/tree/master/examples/volume-attachment)
  
  
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.6 |
| aws | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws_profile | (Optional) Profile of the AWS provider. | `string` | `"default"` | no |
| aws_region | (Optional) Region of the AWS provider. | `string` | `"us-east-1"` | no |
| aws_az1 | (Optional) Availability Zone of Subnet. | `string` | `"us-east-1a"` | no |
| aws_az2 | (Optional) Availability Zone of Subnet. | `string` | `"us-east-1b"` | no |
| instance_type | (Optional) EC2 Instance Name. | `string` | `"t2.micro"` | no |
| boot_image | (Optional) Boot Image to create instance. | `string` | `"ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"` | no |
| boot_canonical | (Optional) Boot Canonical to create instance. | `string` | `"099720109477"` | no |
| virtualization_type | (Optional) Virtualization Type of EC2 AWS. | `string` | `"hvm"` | no |
| tags_name | (Optional) A mapping of tags (Name) to assign to the bucket. | `string` | `"Flugel"` | no |
| tags_owner | (Optional) A mapping of tags (Owner) to assign to the bucket. | `string` | `"InfraTeam"` | no |
| vpc_cidr | (Optional) Block Subnet to configure VPC | `string` | `"192.168.200.0/23"` | no |
| sub_public1_cidr | (Optional) Public Subnet to configure ALB and Web Server Master | `string` | `"192.168.200.0/25"` | no |
| sub_public2_cidr | (Optional) Public Subnet to configure ALB and Web Server Master | `string` | `"192.168.200.128/25"` | no |
| sub_private1_cidr | (Optional) Private Subnet to configure Web Server | `string` | `"192.168.201.0/25"` | no |
| sub_private2_cidr | (Optional) Private Subnet to configure Web Server  | `string` | `"192.168.201.128/25"` | no |
| my_ssh_key_name | (Optional) SSH Key Name | `string` | `"my_ssh_web"` | no |

## Outputs

| Name | Description |
|------|-------------|
| aws_web_master_ip | Public IP configured on instance Web Server Master. |
| aws_web_1_ip | Private IP configured on instance Web Server 1. |
| aws_web_2_ip | Private IP configured on instance Web Server 2. |
| aws_web_master_tags | Tags configured on instance Web Server Master. |
| aws_web_1_tags | Tags configured on instance Web Server 1. |
| aws_web_2_tags | Tags configured on instance Web Server 2. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Ronald Saenz](https://github.com/ronaldsaenz88).

## License

GNU General Public Licensed. See LICENSE for full details.