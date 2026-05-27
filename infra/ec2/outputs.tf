output "ec2_public_ip" {
  description = "웹서버 브라우저 접속을 위한 가상 서버 공인 IP"
  value       = module.ec2_instance.public_ip
}

output "ec2_security_group_id" {
  description = "EC2 가상 서버에 바인딩된 보안그룹 고유 ID"
  value       = aws_security_group.ec2.id
}
