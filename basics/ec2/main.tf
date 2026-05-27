# Data Source: aws_ami
# AWS 관리자 계정에서 제공하는 공식 OS 이미지 목록 중 최신 AMI ID를 동적으로 실시간 조회.
# 하드코딩된 AMI ID를 탈피해 리전 변경 시에도 최신 이미지를 안전하게 가져오는 기법.
data "aws_ami" "amazon_linux_2" {
  most_recent = true       # 매치되는 이미지 중 가장 최신 생성 버전 룩업
  owners      = ["amazon"] # 공식 아마존 소유 이미지로 한정

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"] # 이름 패턴 필터링 (Amazon Linux 2 HVM x86_64 gp2 스토리지 규격)
  }
}

# Data Source: aws_subnet
# 5장 VPC 실습에서 이미 생성된 첫 번째 퍼블릭 서브넷 정보를 Name 태그를 기준으로 동적 조회합니다.
data "aws_subnet" "public" {
  filter {
    name   = "tag:Name"
    values = ["${var.project}-public-subnet-1"]
  }
}

# EC2 Instance Resource: 가상 서버 인스턴스 배포
resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux_2.id # 동적 룩업한 AMI ID 자동 바인딩
  instance_type          = var.instance_type              # variables.tf에 정의된 인스턴스 규격 (예: t3.micro)
  subnet_id              = data.aws_subnet.public.id      # 데이터 소스로 조회한 첫 번째 퍼블릭 서브넷 영역에 배치
  vpc_security_group_ids = [aws_security_group.ec2.id]    # 보안그룹 매핑 (목록 리스트 포맷으로 주입)

  tags = {
    Name = "${var.project}-ec2"
  }
}
