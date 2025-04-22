resource "aws_security_group" "pb_test_securitygrp" {
  name        = "pb_test_securitygrp"
  description = var.security_grp_description
  vpc_id      = var.vpc_id

  tags = {
    Name = "pb_test_securitygrp_tags"
  }
}

resource "aws_vpc_security_group_ingress_rule" "pb_allow_all_traffic_ipv4_ingress" {
  security_group_id = aws_security_group.pb_test_securitygrp.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "pb_allow_all_traffic_ipv4_egress" {
  security_group_id = aws_security_group.pb_test_securitygrp.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}
data "aws_vpc" "default" {
  default = true
}
data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}
locals {
  subnets = [
    for s in data.aws_subnets.all.ids : {
      id = s
      az = data.aws_subnet.info[s].availability_zone
    }
  ]

  unique_azs = { for s in local.subnets : s.az => s.id... }
  distinct_az_subnets = [for az, ids in local.unique_azs : ids[0]]
}

data "aws_subnet" "info" {
  for_each = toset(data.aws_subnets.all.ids)
  id       = each.key
}
resource "aws_security_group" "pb-alb" {
  name="alb-security-grp-pb"
}
resource "aws_security_group_rule" "allow_alb_http_inbound" {
    type = "ingress"
    security_group_id = aws_security_group.pb-alb.id
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

}
resource "aws_security_group_rule" "allow_alb_http_outbound" {
    type = "egress"
    security_group_id = aws_security_group.pb-alb.id
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]

}
