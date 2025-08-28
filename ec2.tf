# Public EC2 Instance (在 Public Subnet)
resource "aws_instance" "public_ec2" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = "t3.micro"
  key_name               = "henry-ec2-key"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.public.id]

  tags = {
    Name = "public-ec2-instance"
  }
}

# Private EC2 Instance (在 Private Subnet)
resource "aws_instance" "private_ec2" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = "t3.micro"
  key_name               = "henry-ec2-key"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.private.id]

  tags = {
    Name = "private-ec2-instance"
  }
}