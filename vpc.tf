# 創建自定義 VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "my-custom-vpc"
  }
}

# 創建 Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-east-2a"
  map_public_ip_on_launch = true  # 這個設定讓在 public subnet 中啟動的 EC2 實例自動獲得公網 IP

  tags = {
    Name = "public-subnet"
  }
}

# 創建 Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-east-2a"

  tags = {
    Name = "private-subnet"
  }
}

# 創建 Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# 創建 Elastic IP for NAT Gateway (給 private subnet 用)
resource "aws_eip" "nat" {
  domain = "vpc"
  
  depends_on = [aws_internet_gateway.main]

  tags = {
    Name = "nat-eip"
  }
}

# 創建 NAT Gateway (給 private subnet 用)
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "main-nat"
  }

  depends_on = [aws_internet_gateway.main]
}

# 創建 Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-rt"
  }
}

# 創建 Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "private-rt"
  }
}

# 關聯 Public Subnet 到 Public Route Table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# 關聯 Private Subnet 到 Private Route Table
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
