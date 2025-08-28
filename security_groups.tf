# Public Security Group (用於 Public Subnet)
resource "aws_security_group" "public" {
  name        = "public-sg"
  description = "Security group for public subnet"
  vpc_id      = aws_vpc.main.id
	
	# 只開放 22/tcp (SSH 連線) 連進來
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

	# 打出去沒有限制
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public-sg"
  }
}

# Private Security Group (用於 Private Subnet)
resource "aws_security_group" "private" {
  name        = "private-sg"
  description = "Security group for private subnet"
  vpc_id      = aws_vpc.main.id

	# 只允許來自 public subnet 的 SSH 連線
  ingress {
    description = "SSH from public subnet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.public.id]
  }

	# 打出去沒有限制 (透過 NAT Gateway)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-sg"
  }
}