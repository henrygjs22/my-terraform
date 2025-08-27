resource "aws_instance" "my_ec2" {
  ami           		 = data.aws_ami.al2023.id  # 對應data_sources.tf 的 data "aws_ami" "al2023" 參數名稱
  instance_type          = "t3.micro"
  key_name               = "henry-ec2-key"  # AWS 裡已存在的 key pair 名稱
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.ssh_only.id]

	tags = {
		Name = "my-first-tf-ec2"
	}
}