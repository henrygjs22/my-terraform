output "ec2_public_ip"   { value = aws_instance.my_ec2.public_ip }
output "ec2_public_dns"  { value = aws_instance.my_ec2.public_dns }
output "security_group"  { value = aws_security_group.ssh_only.id }
output "vpc_id"          { value = data.aws_vpc.default.id }
output "subnet_id"       { value = data.aws_subnets.default.ids[var.subnet_index] }
output "ssh_command" {
  value       = "ssh -i ${var.key_file_path} ${var.ssh_user}@${aws_instance.my_ec2.public_ip}"
}

output "connection_info" {
  value = <<-EOT
    🌐 EC2 連線資訊:
		📍 IP 位址: ${output.ec2_public_ip.value}
		🌍 DNS 名稱: ${output.ec2_public_dns.value}
		🔑 使用者: ${var.ssh_user}
		📁 金鑰檔案: ${var.key_file_path}
    
    🚀 SSH 連線指令 - 直接複製貼上即可登入 EC2:
    ${output.ssh_command.value}
    
    💡 提示: 確保金鑰檔案權限正確 (chmod 400 ./keys/henry-ec2-key.pem)
  EOT
  description = "完整的 EC2 連線資訊和指令"
}