# Module Block: 외부 Terraform Registry에 공식 등록된 VPC 모듈을 가져와 사용.
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = var.project
  cidr = var.vpc_cidr

  azs            = ["ap-northeast-2a", "ap-northeast-2c"]
  public_subnets = [var.public_subnet_cidr, var.public_subnet_2_cidr]

  enable_nat_gateway      = false
  map_public_ip_on_launch = true

  tags = {
    Project = var.project
  }
}
