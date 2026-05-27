# Input Variables: 외부에서 주입되는 매개 변수들을 정의.

variable "env" {
  description = "인프라 환경 구별 값 (파일명과 경로 조합에 사용)"
  type        = string
  default     = "dev"

  # validation block: 입력 값의 유효성 무결성 검증.
  validation {
    condition     = contains(["dev", "prod"], var.env) # dev 또는 prod 값만 허용
    error_message = "오류: env 변수값은 반드시 'dev' 또는 'prod' 중 하나여야 합니다."
  }
}

variable "greeting_message" {
  description = "생성될 파일의 텍스트 콘텐츠 메시지"
  type        = string
  default     = "Hello, Terraform!"
}

# Sensitive Option: plan/apply 출력 시 화면에 노출되지 않도록 제어.
# 실무의 데이터베이스 접근 패스워드, API 토큰 키 등은 반드시 sensitive를 true로 지정.
variable "secret_token" {
  description = "보안 마스킹 처리가 요구되는 민감한 토큰"
  type        = string
  sensitive   = true # 터미널 화면 노출 차단 활성화 (State 파일 내부에는 암호화되지 않은 원문이 남으므로 State 파일 보호 필수)
  default     = "my-secret-token"
}

