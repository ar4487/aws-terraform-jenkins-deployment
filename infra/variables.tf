variable "aws_region" {
    default = "us-east-1"  
}

variable "vpc_cidr" {
    default = "10.0.0.0/16"
  
}

variable "subnet_cidr" {
   default = "10.0.1.0/24"
 }

 variable "instance_type" {
   default = "t3.micro"
 }

variable "key_pair_name" {
   default = "my-key-pair"
}
variable "app_port" {
  default = 3000
}