output "aws_web_master_ip" {
  description = "Public IP configured on instance web master"
  value       = "WEB Master: ${aws_instance.ec2_web_master.public_ip}"
}

output "aws_web_1_ip" {
  description = "Private IP configured on instance web 1"
  value       = "WEB1: ${aws_instance.ec2_web_1.private_ip}"
}

output "aws_web_2_ip" {
  description = "Private IP configured on instance web 2"
  value       = "WEB2: ${aws_instance.ec2_web_2.private_ip}"
}

output "aws_web_master_tags" {
  description = "List of tags of instances web master"
  value       = aws_instance.ec2_web_master.tags
}

output "aws_web_1_tags" {
  description = "List of tags of instances web 1"
  value       = aws_instance.ec2_web_1.tags
}

output "aws_web_2_tags" {
  description = "List of tags of instances web 2"
  value       = aws_instance.ec2_web_2.tags
}
