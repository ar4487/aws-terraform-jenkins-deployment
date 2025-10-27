provider "aws" {
  region = "us-east-1"
}
#vpc
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = { Name = "jenkins-vpc" }
}
#subnet
resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.subnet_cidr
  map_public_ip_on_launch = true
  availability_zone = "${var.aws_region}a"
    tags = { Name = "jenkins-public-subnet" }
}
#Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {Name = "jenkins-igw"}
}
#Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
    tags = { Name = "jenkins-public-rt" }
}
#Associate Subnet -> route table
resource "aws_route_table_association" "public_assoc" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}
#Security Group
resource "aws_security_group" "web_sg" {
    name = "we_sg"
    description = "Allow SSH and HTTP"
    vpc_id = aws_vpc.main.id
    ingress {
        description = "allows ssh"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "allow http"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "allow port 3000"
        from_port = var.app_port
        to_port = var.app_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {Name= "web_sg"}
  
}

# EC2 Instance
resource "aws_instance" "web" {
  ami = "ami-0360c520857e3138f"
  instance_type = var.instance_type
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
    key_name = var.key_pair_name
    user_data = file("userdata.sh")
    tags = { Name = "web-server-instance" }
}