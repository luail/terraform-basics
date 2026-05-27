output "rds_endpoint" {
  description = "RDS 연결 엔드포인트"
  value       = aws_db_instance.main.endpoint
}
