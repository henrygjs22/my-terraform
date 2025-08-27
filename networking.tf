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