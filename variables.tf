variable "region" {
  type        = string
  description = "AWS region"
  default     = "ap-east-2"
}

variable "key_name" {
  type        = string
  description = "henry-ec2-key"  # AWS 裡已存在的 key pair 名稱
}

variable "my_ip" {
  type        = string
  description = "106.105.25.225/32"
}

variable "subnet_index" {
  type        = number
  description = "Index of subnet to use"
  default     = 0
}

variable "ssh_user" {
  type        = string
  description = "SSH user for EC2 instance"
  default     = "ec2-user"
}

variable "key_file_path" {
  type        = string
  description = "Path to SSH private key file"
  default     = "./keys/henry-ec2-key.pem"
}