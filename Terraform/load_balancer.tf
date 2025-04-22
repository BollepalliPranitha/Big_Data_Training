
resource "aws_lb_listener" "pb_http"{
    load_balancer_arn= aws_lb.pb_load_balancer.arn
    port =80
    protocol="HTTP"
    default_action{
        type="fixed-response"
        fixed_response{
            content_type="text/plain"
            message_body="404: page not found"
            status_code=404
        }
    }
}
resource "aws_lb_target_group" "pb_instances" {
  name = "pb-target-group"
  port = 8080
  protocol = "HTTP"
  vpc_id=var.vpc_id
  health_check {
    path = "/"
    protocol = "HTTP"
    matcher="200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}
resource "aws_lb_target_group_attachment" "pr_EC2"{
    target_group_arn = aws_lb_target_group.pb_instances.arn
    target_id = aws_instance.pr_EC2.id
    port = 8080

}
resource "aws_lb_target_group_attachment" "pr1_EC2"{
    target_group_arn = aws_lb_target_group.pb_instances.arn
    target_id = aws_instance.pr1_EC2.id
    port = 8080

}
resource "aws_lb_listener_rule" "pb_instances_rule" {
  listener_arn = aws_lb_listener.pb_http.arn
  priority = 100
  condition{
    path_pattern {
      values = ["*"]
    }
  }
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.pb_instances.arn
  }

}

resource "aws_lb" "pb_load_balancer" {
    name = "web-app-lb-pb"
    load_balancer_type = "application"
    subnets =local.distinct_az_subnets
    security_groups = [aws_security_group.pb-alb.id ]    
}
