variable "region" {
  description = "AWS 리전"
  type        = string
  default     = "ap-northeast-2"
}

variable "project" {
  description = "리소스 이름 접두사로 사용"
  type        = string
  default     = "terraform-course"
}

# plan 출력과 apply 로그 내 값 노출 방지
variable "db_password" {
  description = "RDS 마스터 패스워드"
  type        = string
  sensitive   = true
}
