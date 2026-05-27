terraform {
  required_version = ">= 1.15.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket       = "my-terraform-state-bradko"         # State 파일을 저장할 S3 버킷 이름
    key          = "terraform/my-state/terraform.tfstate" # S3내에 tfstate 파일이 저장될 경로 및 파일명
    region       = "ap-northeast-2"
    use_lockfile = true
  }
}
