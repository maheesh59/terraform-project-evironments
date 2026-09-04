output "instance_id" {
  description = "Jenkins EC2 instance ID"
  value       = aws_instance.this.id
}

output "private_ip" {
  description = "Jenkins private IP"
  value       = aws_instance.this.private_ip
}

output "security_group_id" {
  description = "Jenkins security group ID"
  value       = aws_security_group.jenkins.id
}

output "port" {
  description = "Jenkins application port"
  value       = var.application_port
}
