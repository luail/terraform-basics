# Data Source: aws_subnet (public 1)
# 5장 VPC 실습에서 이미 생성된 첫 번째 퍼블릭 서브넷 정보를 Name 태그를 기준으로 동적 조회합니다.
data "aws_subnet" "public" {
  filter {
    name   = "tag:Name"
    values = ["${var.project}-public-subnet-1"]
  }
}

# Data Source: aws_subnet (public 2)
# 5장 VPC 실습에서 이미 생성된 두 번째 퍼블릭 서브넷 정보를 Name 태그를 기준으로 동적 조회합니다.
data "aws_subnet" "public_2" {
  filter {
    name   = "tag:Name"
    values = ["${var.project}-public-subnet-2"]
  }
}

# DB Subnet Group Resource: RDS 데이터베이스가 배치될 서브넷의 그룹을 지정.
# [AWS RDS 물리 요건]: RDS 가용성 보장을 위해 반드시 서로 다른 가용영역(AZ)에 속한 
# 최소 2개 이상의 서브넷 ID 목록을 subnet_ids에 주입해야 함.
resource "aws_db_subnet_group" "main" {
  name       = "${var.project}-db-subnet-group"
  subnet_ids = [data.aws_subnet.public.id, data.aws_subnet.public_2.id] # 데이터 소스로 조회한 ap-northeast-2a 및 2c 서브넷 ID 매핑

  tags = {
    Name = "${var.project}-db-subnet-group"
  }
}

# RDS Database Instance Resource: MySQL 데이터베이스 서버 배포
resource "aws_db_instance" "main" {
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro" # 프리티어 수용 가능 RDS 사양

  allocated_storage = 20
  db_name           = "appdb"
  username          = "admin"
  password          = var.db_password # variables.tf의 sensitive 변수 값 주입

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id] # RDS 보안 그룹 매핑

  # [주의]: 실습 완료 후 빠른 자원 정리를 위해 최종 스냅샷 생성을 비활성화(true) 처리.
  # 실제 운영 환경에서는 데이터 보존을 위해 반드시 false로 설정하고 스냅샷 이름을 선언해야 함.
  skip_final_snapshot = true

  # [운영 필수 안전장치]: 인프라 리팩토링이나 실수에 의한 DB 자원 완전 파괴 유실을 원천 차단.
  # lifecycle {
  #   prevent_destroy = true # terraform destroy 명령 구동 시 삭제 에러를 내며 동작을 중단시키는 방어벽
  # }

  tags = {
    Name = "${var.project}-rds"
  }
}
