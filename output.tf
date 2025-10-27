output "ec2_public_ip" {
   description = "Public IP of EC2"
  value = aws_instance.web.public_ip
}
output "ec2_instance_id" {
  value = aws_instance.web.id
}
output "vpc_id" {
  value = aws_vpc.main.id
}