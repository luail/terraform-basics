output "vpc_id" {
  description = "생성 완료된 VPC 고유 ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "EC2가 있는 첫 번째 서브넷 ID"
  value       = module.vpc.public_subnets[0]
}

output "public_subnets" {
  description = "전체 퍼블릭 서브넷 ID 리스트"
  value       = module.vpc.public_subnets
}
