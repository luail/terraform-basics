# VPC (Virtual Private Cloud) Resource: 격리된 가상 네트워크 망을 정의.
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr # VPC가 확보할 IP 대역 지정 (예: 10.0.0.0/20)

  tags = {
    Name = "${var.project}-vpc"
  }
}

# Public Subnet 1 Resource: 첫 번째 가용영역(AZ 2a)에 위치한 퍼블릭 서브넷
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "ap-northeast-2a" # 가용영역 2a 지정
  map_public_ip_on_launch = true              # 이 서브넷에서 실행되는 EC2 등에 AWS 공인 IP를 자동 할당하도록 설정

  tags = {
    Name = "${var.project}-public-subnet-1"
  }
}

# Public Subnet 2 Resource: 두 번째 가용영역(AZ 2c)에 위치한 퍼블릭 서브넷 (이중화 및 RDS 서브넷 그룹 대비용)
resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = "ap-northeast-2c" # 가용영역 2c 지정
  map_public_ip_on_launch = true              # 공인 IP 자동 할당 설정

  tags = {
    Name = "${var.project}-public-subnet-2"
  }
}

# Internet Gateway (IGW) Resource: VPC의 가상 서버가 인터넷과 통신하기 위한 관문
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id # 게이트웨이를 대상 VPC에 매핑

  tags = {
    Name = "${var.project}-igw"
  }
}

# Route Table Resource: 서브넷별 네트워크 트래픽 흐름을 통제하는 라우팅 규칙판
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  # default route: 모든 외부행(0.0.0.0/0) 인터넷 트래픽을 상기 생성한 IGW로 전달
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project}-public-rt"
  }
}

# Route Table Association:
# 서브넷 1과 2를 공통의 퍼블릭 라우팅 테이블(IGW행)에 매핑하여 퍼블릭 서브넷으로 동작하도록 선언.
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}


