# Outputs Block: 배포 완료 후 리소스의 특정 속성을 터미널 화면에 노출하거나
# 상위 모듈로 값을 반환하기 위해 정의.

output "hello_file_path" {
  description = "생성된 hello 파일의 절대 경로"
  value       = local_file.hello.filename
}

output "greeting_file_path" {
  description = "생성된 greeting 파일의 절대 경로"
  value       = local_file.greeting.filename
}

# Output Sensitive: output 역시 sensitive 설정 시 마스킹 렌더링 적용.
# 단, `terraform output -json` 등으로 파싱 시에는 원문 조회가 가능함을 주의.
output "secret_token" {
  description = "화면 출력이 통제된 민감 토큰 값"
  value       = var.secret_token
  sensitive   = true # CLI output에 노출 차단
}

