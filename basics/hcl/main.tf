# HCL 주요 데이터 타입
# locals {
#   name    = "hello"          # string: 큰따옴표로 감싼 문자열
#   port    = 3306             # number: 따옴표 없이 숫자
#   enabled = true             # bool: true 또는 false
#   zones   = ["a", "b", "c"] # list: 대괄호 안에 값 나열
#   tags    = { env = "dev" }  # map: 중괄호 안에 키-값 쌍
# }

# 테라폼 CLI 및 Provider 버전 정의
terraform {
  required_version = ">= 1.15.0"

  required_providers {
    local = {
      source  = "hashicorp/local" # HashiCorp 공식 로컬 파일 제어용 Provider
      version = "~> 2.0"          # 2.x 메이저 버전 고정 호출 (하위 호환성 유지)
    }
  }
}

# Provider 설정 정의
provider "local" {}

# 실물 자원(로컬 파일) 정의
resource "local_file" "hello" {
  filename = "${path.module}/output/hello.txt" # 현재 테라폼 파일이 위치한 디렉토리 절대 경로
  content  = "Hello, Terraform!(fix)"
}

# 리소스 간 참조 
# hello 리소스의 content 속성을 greeting 리소스가 직접 참조
# 테라폼이 종속성 그래프를 연산해 생성 순서(hello -> greeting)를 자동 결정
resource "local_file" "greeting" {
  filename = "${path.module}/output/greeting.txt"
  content  = "hello.txt 내용: ${local_file.hello.content}" # 타 리소스의 속성값 동적 매핑
}
