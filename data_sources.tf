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