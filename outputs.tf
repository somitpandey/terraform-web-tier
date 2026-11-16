output "vpc_id" {
  description = "The ID of the VPC created for the lab"
  value       = aws_vpc.main.id
}

output "alb_dns_name" {
  description = "DNS name of the application load balancer"
  value       = aws_lb.web.dns_name
}

output "alb_zone_id" {
  description = "Hosted zone ID of the application load balancer"
  value       = aws_lb.web.zone_id
}

output "autoscaling_group_name" {
  description = "Name of the web autoscaling group"
  value       = aws_autoscaling_group.web.name
}
