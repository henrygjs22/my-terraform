# VPC 和 Subnet 資訊
output "vpc_id"          { value = aws_vpc.main.id }
output "vpc_cidr"        { value = aws_vpc.main.cidr_block }
output "public_subnet_id" { value = aws_subnet.public.id }
output "private_subnet_id" { value = aws_subnet.private.id }

# Public EC2 資訊
output "public_ec2_ip"   { value = aws_instance.public_ec2.public_ip }
output "public_ec2_dns"  { value = aws_instance.public_ec2.public_dns }
output "public_ec2_private_ip" { value = aws_instance.public_ec2.private_ip }

# Private EC2 資訊
output "private_ec2_private_ip" { value = aws_instance.private_ec2.private_ip }

# Security Groups
output "public_sg_id"    { value = aws_security_group.public.id }
output "private_sg_id"   { value = aws_security_group.private.id }

output "connection_info" {
  value = <<-EOT
    🌐 VPC 資訊:
    📍 VPC ID: ${aws_vpc.main.id}
    🌍 VPC CIDR: ${aws_vpc.main.cidr_block}
    🔗 Public Subnet: ${aws_subnet.public.id} (${aws_subnet.public.cidr_block})
    🔒 Private Subnet: ${aws_subnet.private.id} (${aws_subnet.private.cidr_block})
    
    🖥️ Public EC2 實例:
    📍 公網 IP: ${aws_instance.public_ec2.public_ip}
    🌍 DNS: ${aws_instance.public_ec2.public_dns}
    🔑 內網 IP: ${aws_instance.public_ec2.private_ip}
    
    🖥️ Private EC2 實例:
    🔑 內網 IP: ${aws_instance.private_ec2.private_ip}
    
    🚀 SSH 連線指令:
    📱 連線到 Public EC2: ssh -i ${var.key_file_path} ${var.ssh_user}@${aws_instance.public_ec2.public_ip}
    🔒 透過 Public EC2 連線到 Private EC2: ssh -i ${var.key_file_path} ${var.ssh_user}@${aws_instance.private_ec2.private_ip}
    
    💡 測試 Private EC2 網路連線:
    1. 先 SSH 到 Public EC2
    2. 再從 Public EC2 SSH 到 Private EC2
    3. 在 Private EC2 中測試: curl google.com
  EOT
  description = "完整的 VPC 和 EC2 連線資訊"
}