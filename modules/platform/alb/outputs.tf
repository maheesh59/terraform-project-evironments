output "alb_dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.this.dns_name
}

output "alb_security_group_id" {
  description = "ALB security group ID"
  value       = aws_security_group.alb.id
}

output "jenkins_instance_id" {
  description = "Jenkins instance ID"
  value       = var.enable_jenkins ? module.jenkins[0].instance_id : null
}

output "nexus_instance_id" {
  description = "Nexus EC2 instance ID"
  value       = var.enable_nexus ? module.nexus[0].instance_id : null
}

output "nexus_private_ip" {
  description = "Nexus private IP address"
  value       = var.enable_nexus ? module.nexus[0].private_ip : null
}

output "jenkins_url" {
  description = "Jenkins URL"
  value = var.enable_jenkins ? (
    "http://${aws_lb.this.dns_name}:${var.jenkins_listener_port}"
  ) : null
}

output "nexus_url" {
  description = "Nexus UI URL"
  value = var.enable_nexus ? (
    "http://${aws_lb.this.dns_name}:${var.nexus_listener_port}"
  ) : null
}

output "sonarqube_instance_id" {
  description = "SonarQube EC2 instance ID"
  value       = var.enable_sonarqube ? module.sonarqube[0].instance_id : null
}

output "sonarqube_url" {
  description = "SonarQube UI URL"
  value = var.enable_sonarqube ? (
    "http://${aws_lb.this.dns_name}:${var.sonarqube_listener_port}"
  ) : null
}
