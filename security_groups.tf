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
    cidr_blocks = [var.my_ip]
  }

	# 打出去沒有限制
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}