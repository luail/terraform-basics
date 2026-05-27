# Data Source: 타 EC2 스택의 State 정보 로드
data "terraform_remote_state" "ec2" {
  backend = "s3"

  config = {
    bucket = "my-terraform-state-bradko"
    key    = "terraform/infra/ec2/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

# RDS Security Group Resource: 데이터베이스 방화벽
resource "aws_security_group" "rds" {
  name   = "${var.project}-rds-sg"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id # VPC 모듈의 Output vpc_id 참조

  ingress {
    description     = "MySQL from EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.ec2.outputs.ec2_security_group_id] # EC2 SG를 보유한 자원만 허용
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
