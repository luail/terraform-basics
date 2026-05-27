output "rds_endpoint" {
  description = "데이터베이스 애플리케이션 연결 엔드포인트 주소"
  value       = module.db.db_instance_endpoint
}
