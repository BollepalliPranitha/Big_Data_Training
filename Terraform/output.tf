output "ec2-instance-ami"{
    value=data.aws_ami.ec2-latest.id
}
output "alb_dns_name" {
  value = aws_lb.pb_load_balancer.dns_name
}