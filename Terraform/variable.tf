variable  "ami_instance" {
    type=string
    default="al2023-ami-2023.7.20250331.0-kernel-6.1-x86_64"
}
variable "owners"{
    type=string
    default="137112412989"
}
variable "instance_type"{
    type=string
    default="t2.micro"
}
variable "vpc_id"{
    type=string
    default="vpc-0e13ae6de03f62cd5"
}
variable "security_grp_description"{
    type=string
    default="Allow TLS inbound traffic and all outbound traffic"
}
