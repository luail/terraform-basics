variable "project" {
  description = "리소스 이름 접두사로 사용 (예: terraform-course-vpc)"
  type        = string
  default     = "terraform-course"
}

variable "region" {
  description = "AWS 리전 지정"
  type        = string
  default     = "ap-northeast-2"
}

variable "vpc_cidr" {
  description = "VPC CIDR 블록 대역"
  type        = string
  default     = "10.0.0.0/20"
}

variable "public_subnet_cidr" {
  description = "첫 번째 Public Subnet CIDR 블록"
  type        = string
  default     = "10.0.0.0/24"
}

variable "public_subnet_2_cidr" {
  description = "두 번째 Public Subnet CIDR 블록"
  type        = string
  default     = "10.0.1.0/24"
}
