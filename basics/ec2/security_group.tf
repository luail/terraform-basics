# Data Source: aws_vpc
# 5장 VPC 실습에서 이미 생성된 VPC 정보를 Name 태그를 기준으로 동적 조회합니다.
data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["${var.project}-vpc"]
  }
}

# EC2 Security Group Resource: 가상 서버용 인/아웃바운드 방화벽 규칙
resource "aws_security_group" "ec2" {
  name   = "${var.project}-ec2-sg"
  vpc_id = data.aws_vpc.main.id # 데이터 소스로 조회한 VPC ID 바인딩

  # [Ingress Rules (인바운드)]: 외부에서 가상 서버로 들어오는 허용 규칙
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 전체 공개 웹서비스 포트
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # SSL 보안 접속용 전체 공개 포트
  }

  # [Egress Rules (아웃바운드)]: 가상 서버 내부에서 외부로 나가는 트래픽 규칙
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # "-1"은 모든 프로토콜(All Traffic) 허용 의미
    cidr_blocks = ["0.0.0.0/0"] # 외부 패치 업데이트 등을 위해 전부 개방
  }

  tags = {
    Name = "${var.project}-ec2-sg"
  }
}
