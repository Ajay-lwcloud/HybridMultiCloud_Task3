provider "aws" {

region = “ap-south-1”

profile = “default”

}

resource “aws_vpc” “myvpc”{

cidr_block = “192.168.0.0/16”

instance_tenancy = “default”

enable_dns_hostnames = true

tags = {

Name = “vpc”

}

}

resource "aws_subnet" "public" {

vpc_id = aws_vpc.vpc.id

cidr_block = "192.168.10.0/24"

availability_zone = "ap-south-1b"

map_public_ip_on_launch = "true"

tags = {

Name = "public-subnet"

}

}


resource "aws_subnet" "private" {

vpc_id = aws_vpc.vpc.id

cidr_block = "192.168.20.0/24"

availability_zone = "ap-south-1a"

tags = {

Name = "private-subnet"

}

}


resource "aws_internet_gateway" "gateway" {

vpc_id = aws_vpc.myvpc.id

tags = {

Name = "gateway"

}

}


resource "aws_route_table" "route" {

vpc_id = aws_vpc.vpc.id

route {

cidr_block = "0.0.0.0/0"

gateway_id = aws_internet_gateway.gateway.id

}

tags = {

Name = "gatewayroute"

}

}

resource "aws_route_table_association" "public"

{

subnet_id = aws_subnet.public.id

route_table_id = aws_route_table.route.id

}


resource "aws_security_group" "tsk3" {

name = "task3"

description = "Allow inbound traffic"

vpc_id = aws_vpc.myvpc.id

ingress {

from_port = 80

to_port = 80

protocol = "tcp"

cidr_blocks = ["0.0.0.0/0"]

}

ingress {

from_port = 22

to_port = 22

protocol = "tcp"

cidr_blocks = ["0.0.0.0/0"]

}

egress {

from_port = 0

to_port = 0

protocol = "-1"

cidr_blocks = ["0.0.0.0/0"]

}

tags = {

Name = "task3"

}

}


resource "aws_instance" "wordpress" {

ami = "ami-004a955bfb611bf13"

instance_type = "t2.micro"

associate_public_ip_address = true

subnet_id = aws_subnet.public.id

vpc_security_group_ids = [ aws_security_group.task3.id]

key_name = "ajay_key_2"

tags = {

Name = "os"

}

}

