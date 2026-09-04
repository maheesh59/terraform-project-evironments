output "instance_id" {
  description = "Nexus EC2 instance ID"
  value       = aws_instance.this.id
}

output "private_ip" {
  description = "Nexus private IP"
  value       = aws_instance.this.private_ip
}

output "security_group_id" {
  description = "Nexus security group ID"
  value       = aws_security_group.nexus.id
}

output "nexus_port" {
  description = "Nexus UI/API port"
  value       = var.nexus_port
}
