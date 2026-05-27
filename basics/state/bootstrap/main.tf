# S3 Backend Bootstrap Configuration
terraform {
  required_version = ">= 1.15.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

# S3 Bucket Resource: 테라폼 State 원격 보관 버킷
resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-terraform-state-bradko" # 전세계에서 유일해야 하는 버킷명

  # lifecycle 블록은 리소스의 생성, 수정, 삭제 동작을 제어하는 설정
  # prevent_destroy 옵션은 실수로 리소스가 삭제되는 것을 방지
  # Terraform destroy 명령어로 이 리소스를 삭제하려고 하면 false로 바꾼 뒤 apply 후에 destroy 가능
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "terraform-state"
  }
}

# S3 Bucket Versioning: 버킷 버전 관리 활성화
# State 파일 손상이나 덮어쓰기 사고 발생 시 과거 버전 추적 및 복구에 필수.
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled" # 버저닝 관리 활성화
  }
}

