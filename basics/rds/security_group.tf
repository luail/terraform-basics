# Data Source: aws_vpc
# 5장 VPC 실습에서 이미 생성된 VPC 정보를 Name 태그를 기준으로 동적 조회합니다.
data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["${var.project}-vpc"]
  }
}

# Data Source: aws_security_group
# 6장 EC2 실습에서 이미 생성된 EC2 보안 그룹 정보를 Name 태그를 기준으로 동적 조회합니다.
data "aws_security_group" "ec2" {
  filter {
    name   = "tag:Name"
    values = ["${var.project}-ec2-sg"]
  }
}

# RDS Security Group Resource: 데이터베이스 보안 그룹
# EC2에서 오는 3306 포트 트래픽만 엄격히 통제하여 인입.
resource "aws_security_group" "rds" {
  name   = "${var.project}-rds-sg"
  vpc_id = data.aws_vpc.main.id # 데이터 소스로 조회한 VPC ID 바인딩

  # [RDS 인바운드 제한]: 소스 대상으로 개별 IP 대역 대신 EC2 보안 그룹 ID 자체를 바인딩하여,
  # 해당 EC2 보안 그룹을 부여받아 가동 중인 서버들만 DB 접근을 통과시키는 보안 모범 사례.
  ingress {
    description     = "MySQL from EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [data.aws_security_group.ec2.id] # 데이터 소스로 조회한 EC2 보안 그룹 ID 매핑
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-rds-sg"
  }
}
