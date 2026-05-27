# Data Source: 타 VPC 스택의 State 정보 로드
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "my-terraform-state-bradko"
    key    = "terraform/infra/vpc/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

# Module Block: AWS 공식 레지스트리 RDS 모듈 적용
module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 6.10"

  identifier = "${var.project}-rds"

  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name                             = "appdb"
  username                            = "admin"
  password                            = var.db_password
  port                                = "3306"
  iam_database_authentication_enabled = false

  vpc_security_group_ids = [aws_security_group.rds.id]

  # DB subnet group (모듈 내부에서 자동 생성하도록 설정)
  create_db_subnet_group = true
  subnet_ids             = data.terraform_remote_state.vpc.outputs.public_subnets

  # 별도의 파라미터 그룹/옵션 그룹 생성을 비활성화하여 자원 간소화
  create_db_parameter_group = false
  create_db_option_group    = false

  # 빠른 실습 자원 삭제를 위해 true 설정
  skip_final_snapshot = true

  # 실수로 인한 RDS 삭제 완전 차단 (테라폼 모듈의 삭제 보호 속성 활용)
  deletion_protection = false

  tags = {
    Project = var.project
  }
}
