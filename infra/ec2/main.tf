# Data Source: aws_ami OS 이미지 동적 조회
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Data Source: 타 스택의 State 정보 로드 (VPC ID, Subnet ID 참조용)
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "my-terraform-state-bradko"
    key    = "terraform/infra/vpc/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

# Module Block: AWS 공식 레지스트리 EC2 모듈 적용
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.6"

  name = "${var.project}-ec2"

  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = data.terraform_remote_state.vpc.outputs.public_subnet_id
  vpc_security_group_ids = [aws_security_group.ec2.id]

  tags = {
    Project = var.project
  }
}
