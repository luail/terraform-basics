provider "local" {}

# Resource Block: 입력 변수(var) 및 로컬 변수(local)를 활용한 파일 생성
resource "local_file" "hello" {
  filename = local.hello_path     # locals.tf에 선언된 로컬 변수 참조
  content  = var.greeting_message # variables.tf에 선언된 입력 변수 참조
}

resource "local_file" "greeting" {
  filename = local.greeting_path
  content  = "hello.txt 내용: ${local_file.hello.content}"
}

