output "vpc_id" {
  description = "조회된 VPC ID"
  value       = data.aws_vpc.main.id
}

output "public_subnet_id" {
  description = "조회된 Public Subnet ID"
  value       = data.aws_subnet.public.id
}

output "ec2_public_ip" {
  description = "EC2 인스턴스 공인 IP"
  value       = aws_instance.web.public_ip
}
