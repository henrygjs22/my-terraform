provider "aws" {
  region = "ap-east-2"
}

# 映像檔 (OS + 軟體 + 設定的打包檔)
# 資料來源自動查詢最新 AMI
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]  # AL2023, x86_64
  }
  filter { 
    name   = "architecture"
    values = ["x86_64"] 
  }
  filter { 
    name   = "virtualization-type"
    values = ["hvm"] 
  }
  filter { 
    name   = "root-device-type"
    values = ["ebs"] 
  }
}

# 取 default 的 VPC 和 Subnet（若沒有 default 會報錯）
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]  # 對應上面的 data "aws_vpc" "default"
  }
}

# Securty Group (防火牆)
resource "aws_security_group" "ssh_only" {
  name        = "allow-ssh-from-my-ip"
  description = "Allow SSH from my IP"
  vpc_id      = data.aws_vpc.default.id
	
	# 只開放 22/tcp (SSH 連線) 連進來
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["106.105.25.225/32"]  # 你的電腦所在ip
  }

	# 打出去沒有限制
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_ec2" {
  ami           				 = data.aws_ami.al2023.id  # 對應上面的 data "aws_ami" "al2023" 參數名稱
  instance_type          = "t3.micro"
  key_name               = "henry-ec2-key"  # AWS 裡已存在的 key pair 名稱
	subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.ssh_only.id]

	tags = {
		Name = "my-first-tf-ec2"
	}
}