data "aws_ami" "ec2-latest" {
  most_recent = true
    owners=[var.owners]

   filter {
    name   = "name"
    values = [var.ami_instance]
  }
}
resource "aws_instance" "pb_EC2" {
  ami = data.aws_ami.ec2-latest.id
  instance_type = var.instance_type
   tags = {
    Name = "pbec2"
   }
    vpc_security_group_ids = [ aws_security_group.pb_test_securitygrp.id ]
}
resource "aws_instance" "pr_EC2" {
  ami = data.aws_ami.ec2-latest.id
  instance_type = var.instance_type
   tags = {
    Name = "prec2"
   }
   vpc_security_group_ids = [ aws_security_group.pb_test_securitygrp.id ]
   user_data = <<-EOF
            #!/bin/bash
            echo "Hello World 1" > /home/ec2-user/index.html
            cd /home/ec2-user
            python3 -m http.server 8080 &
            EOF
}


resource "aws_instance" "pr1_EC2" {
  ami = data.aws_ami.ec2-latest.id
  instance_type = var.instance_type
   tags = {
    Name = "pr1ec2"
   }
   vpc_security_group_ids = [ aws_security_group.pb_test_securitygrp.id ]
   user_data = <<-EOF
                #!/bin/bash
                echo "Hello World 2" > /home/ec2-user/index.html
                cd /home/ec2-user
                python3 -m http.server 8080 &
                EOF
}
