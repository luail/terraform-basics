variable "project" {
  description = "리소스 이름 접두사로 사용"
  type        = string
  default     = "terraform-course"
}

variable "region" {
  description = "AWS 리전 지정"
  type        = string
  default     = "ap-northeast-2"
}

variable "db_password" {
  description = "RDS 마스터 데이터베이스 접근 패스워드"
  type        = string
  sensitive   = true
}
