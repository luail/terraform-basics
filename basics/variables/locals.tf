# Locals Block: 코드 파일 내부에서만 참조 및 재사용할 수 있는 "상수 값"을 정의.
# 외부에서 입력되는 variable과 달리, 내부에 고정하거나 복잡한 수식을 가독성 있게 래핑할 때 사용.
locals {
  # env 값에 따라 출력 디렉토리를 동적으로 변경하여 멱등성 및 격리 수준을 유지.
  hello_path    = "${path.module}/output/${var.env}/hello.txt"
  greeting_path = "${path.module}/output/${var.env}/greeting.txt"
}

