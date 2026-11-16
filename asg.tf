resource "aws_launch_template" "web" {
  name_prefix            = "lab-web-"
  image_id               = data.aws_ssm_parameter.al2023.value
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data = base64encode(<<-EOT
#!/bin/bash
dnf install -y nginx
echo "Hello from $(hostname -f)" > /usr/share/nginx/html/index.html
systemctl enable --now nginx
EOT
  )
}
resource "aws_autoscaling_group" "web" {
  min_size            = 2
  desired_capacity    = 2
  max_size            = 3
  vpc_zone_identifier = aws_subnet.public[*].id
  target_group_arns   = [aws_lb_target_group.web.arn]
  health_check_type   = "ELB"
  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }
}
resource "aws_autoscaling_policy" "cpu" {
  name                   = "cpu-50"
  autoscaling_group_name = aws_autoscaling_group.web.name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50
  }
}
output "alb_dns" { value = aws_lb.web.dns_name }
