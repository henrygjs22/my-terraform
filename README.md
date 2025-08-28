# 🚀 Terraform AWS EC2 專案

這是一個使用 Terraform 建立 AWS EC2 實例的基礎專案，適合學習 Terraform 和 AWS 基礎架構。

## 📋 專案概述

### 🎯 功能特色
- ✅ 自動建立自定義 VPC 和 Subnet
- ✅ 建立 Public 和 Private Subnet
- ✅ 配置 Internet Gateway 和 NAT Gateway
- ✅ 建立兩個 EC2 實例（Public 和 Private）
- ✅ 配置安全群組（Public 和 Private）
- ✅ 使用現有的 Key Pair 進行 SSH 認證
- ✅ 自動查詢最新的 AMI
- ✅ 提供完整的連線資訊輸出
- ✅ 包含網路連線測試腳本

### 🏗️ 架構圖

#### 原始架構（使用預設 VPC）
```
Internet
    │
    ▼
Security Group (SSH only)
    │
    ▼
EC2 Instance (t3.micro)
    │
    ▼
Default VPC/Subnet
```

#### 新架構（自定義 VPC with Public/Private Subnets）
```
                ┌─────────────────────────────────────────────────────────────┐
                │                    VPC 10.0.0.0/16                        │
                │                                                             │
                │  ┌─────────────────────────────────────────────────────┐   │
                │  │              Route Tables                          │   │
                │  │  ┌─────────────────┐    ┌─────────────────┐        │   │
                │  │  │ Public Route    │    │ Private Route   │        │   │
                │  │  │ Table           │    │ Table           │        │   │
                │  │  │ 0.0.0.0/0 → IGW │    │ 0.0.0.0/0 → NAT │        │   │
                │  │  └─────────────────┘    └─────────────────┘        │   │
                │  └─────────────────────────────────────────────────────┘   │
                │                                                             │
        ┌─────────────────────────────────────────────────────────────────────┐
        │                                                                     │
        │  ┌─────────────────────────────┐        ┌─────────────────────────┐ │
        │  │      Public Subnet          │        │     Private Subnet      │ │
        │  │      10.0.1.0/24            │        │     10.0.2.0/24         │ │
        │  │      ap-east-2a             │        │     ap-east-2a          │ │
        │  │                             │        │                         │ │
        │  │  ┌─────────────────────────┐ │        │  ┌─────────────────────┐ │ │
        │  │  │   Public EC2 Instance   │ │        │  │  Private EC2 Instance│ │ │
        │  │  │                         │ │        │  │                     │ │ │
        │  │  │ 內網 IP: 10.0.1.10      │ │        │  │ 內網 IP: 10.0.2.10   │ │ │
        │  │  │ 公網 IP: 3.123.45.67    │ │        │  │ 公網 IP: 無          │ │ │
        │  │  │                         │ │        │  │                     │ │ │
        │  │  │ Security Group:         │ │        │  │ Security Group:      │ │ │
        │  │  │ - SSH (22) from My IP   │ │        │  │ - SSH (22) from      │ │ │
        │  │  │ - All outbound          │ │        │  │   Public SG only     │ │ │
        │  │  └─────────────────────────┘ │        │  │ - All outbound       │ │ │
        │  └─────────────────────────────┘        │  └─────────────────────┘ │ │
        │                                          │                         │ │
        │  ┌─────────────────────────────────────┐ │  ┌─────────────────────┐ │ │
        │  │        Route Table Association      │ │  │   Route Table        │ │ │
        │  │     Public Subnet → Public RT       │ │  │   Association        │ │ │
        │  └─────────────────────────────────────┘ │  │Private Subnet→Private│ │ │
        │                                          │  │        RT            │ │ │
        └──────────────────────────────────────────┘  └─────────────────────┘ │
                                                         │                     │
                                                         └─────────────────────┘
                │                                                             │
                │  ┌─────────────────────────────────────────────────────┐   │
                │  │              Gateways                              │   │
                │  │  ┌─────────────────┐    ┌─────────────────┐        │   │
                │  │  │ Internet        │    │ NAT Gateway     │        │   │
                │  │  │ Gateway         │    │                 │        │   │
                │  │  │                 │    │ EIP: 3.123.45.68│        │   │
                │  │  │ 雙向連線        │    │ 單向連線        │        │   │
                │  │  │ (進得來出得去)   │    │ (出得去進不來)   │        │   │
                │  │  └─────────────────┘    └─────────────────┘        │   │
                │  └─────────────────────────────────────────────────────┘   │
                └─────────────────────────────────────────────────────────────┘
                                    │
                                    │
                           ┌────────▼────────┐
                           │    Internet     │
                           │                 │
                           │  ┌─────────────┐│
                           │  │  google.com ││
                           │  │  github.com ││
                           │  │  aws.com    ││
                           │  └─────────────┘│
                           └─────────────────┘

#### 網路流量路徑說明：

1. **Public EC2 → Internet:**
   ```
   Public EC2 (10.0.1.10) → Public Route Table → Internet Gateway → Internet
   ```

2. **Private EC2 → Internet:**
   ```
   Private EC2 (10.0.2.10) → Private Route Table → NAT Gateway → EIP (3.123.45.68) → Internet
   ```

3. **Internet → Public EC2:**
   ```
   Internet → Internet Gateway → Public Route Table → Public EC2 (10.0.1.10)
   ```

4. **SSH to Private EC2:**
   ```
   Your PC → Internet → Internet Gateway → Public EC2 → Private EC2 (10.0.2.10)
   ```

## 📁 檔案結構

```
my-terraform/
├── provider.tf          # AWS Provider 配置
├── variables.tf         # 輸入變數定義
├── data_sources.tf      # 資料來源（AMI、VPC、Subnet）
├── vpc.tf              # VPC、Subnet、Gateway 配置
├── security_groups.tf   # 安全群組配置
├── ec2.tf              # EC2 實例配置
├── output.tf           # 輸出值
├── terraform.tfvars    # 變數值（不提交到 Git）
├── test_network.sh     # 網路連線測試腳本
├── .gitignore          # Git 忽略檔案
└── keys/               # SSH 金鑰目錄（不提交到 Git）
    └── henry-ec2-key.pem
```

## 🛠️ 前置需求

### 必要工具
- [Terraform](https://www.terraform.io/downloads) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) 已配置
- SSH 客戶端

### AWS 準備
- AWS 帳戶和存取金鑰
- 已存在的 Key Pair（用於 SSH 連線）
- 目標區域的預設 VPC

## 🚀 快速開始

### 1. 複製專案
```bash
git clone <your-repo-url>
cd my-terraform
```

### 2. 複製 SSH 金鑰
```bash
# 建立 keys 目錄
mkdir keys

# 複製你的 SSH 私鑰到 keys 目錄
cp /path/to/your-key.pem keys/henry-ec2-key.pem

# 設定正確權限（Linux/Mac）
chmod 400 keys/henry-ec2-key.pem
```

### 3. 配置變數
```bash
# 複製範例檔案
cp example.tfvars terraform.tfvars

# 編輯 terraform.tfvars
nano terraform.tfvars
```

填入你的實際值：
```hcl
key_name = "your-key-pair-name"
my_ip    = "your-public-ip/32"
# region = "ap-east-2"  # 可選，預設為 ap-east-2
```

### 4. 初始化 Terraform
```bash
terraform init
```

### 5. 檢視計劃
```bash
terraform plan
```

### 6. 部署基礎架構
```bash
terraform apply
```

### 7. 連接到 EC2
```bash
# 連接到 Public EC2
ssh -i ./keys/henry-ec2-key.pem ec2-user@<PUBLIC-EC2-IP>

# 從 Public EC2 連接到 Private EC2
ssh -i ./keys/henry-ec2-key.pem ec2-user@<PRIVATE-EC2-PRIVATE-IP>

# 或直接複製輸出的指令
terraform output ssh_public_ec2
terraform output ssh_private_ec2
```

### 8. 測試網路連線
```bash
# 執行網路測試腳本
chmod +x test_network.sh
./test_network.sh

# 或在 Private EC2 中測試網際網路連線
curl -I google.com
```

## 📊 輸出資訊

部署完成後，你會看到以下輸出：

- **EC2 公網 IP**：用於 SSH 連線
- **EC2 DNS 名稱**：完整的 DNS 名稱
- **安全群組 ID**：防火牆規則 ID
- **VPC ID**：虛擬私有雲 ID
- **Subnet ID**：子網路 ID
- **SSH 連線指令**：可直接複製貼上的連線指令
- **完整連線資訊**：包含所有連線細節的格式化輸出

## ⚙️ 配置選項

### 主要變數

| 變數名稱 | 描述 | 預設值 | 必填 |
|---------|------|--------|------|
| `region` | AWS 區域 | `ap-east-2` | 否 |
| `key_name` | Key Pair 名稱 | - | 是 |
| `my_ip` | 你的公網 IP/CIDR | - | 是 |
| `ssh_user` | SSH 使用者 | `ec2-user` | 否 |
| `key_file_path` | SSH 私鑰路徑 | `./keys/henry-ec2-key.pem` | 否 |
| `subnet_index` | 使用的 Subnet 索引 | `0` | 否 |

### 資源規格

- **EC2 實例類型**：`t3.micro`
- **作業系統**：Amazon Linux 2023
- **安全群組**：只開放 SSH (22/tcp)
- **網路**：使用預設 VPC 和 Subnet

## 🔧 自訂配置

### 修改實例類型
編輯 `ec2.tf`：
```hcl
instance_type = "t3.small"  # 改為其他類型
```

### 修改安全群組規則
編輯 `security_groups.tf`：
```hcl
# 加入 HTTP 規則
ingress {
  description = "HTTP"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
```

### 加入標籤
編輯 `ec2.tf`：
```hcl
tags = {
  Name        = "my-first-tf-ec2"
  Environment = "dev"
  Project     = "terraform-learning"
}
```

## 🧹 清理資源

### 刪除所有資源
```bash
terraform destroy
```

### 確認刪除
```bash
terraform plan
```

## ⚠️ 注意事項

### 安全性
- 🔒 SSH 金鑰檔案不要提交到 Git
- 🔒 `terraform.tfvars` 包含敏感資訊，不要提交
- 🔒 定期更換 SSH 金鑰對
- 🔒 考慮使用 AWS Systems Manager Session Manager

### 成本
- 💰 t3.micro 在免費方案內（每月 750 小時）
- 💰 記得在不需要時執行 `terraform destroy`
- 💰 監控 AWS 帳單

### 最佳實踐
- 📝 使用版本控制管理 Terraform 程式碼
- 📝 定期更新 Terraform 和 Provider 版本
- 📝 使用 `.terraform.lock.hcl` 確保版本一致性
- 📝 考慮使用 Terraform Cloud 或 AWS S3 作為後端

## 🐛 常見問題

### Q: SSH 連線失敗
**A:** 檢查以下項目：
- SSH 金鑰檔案權限是否正確
- Security Group 是否開放 SSH
- 你的 IP 是否在允許清單中

### Q: AMI 找不到
**A:** 確認：
- AWS 區域設定是否正確
- 是否有該區域的 Amazon Linux 2023 AMI

### Q: Key Pair 不存在
**A:** 在目標區域建立 Key Pair：
```bash
aws ec2 create-key-pair --key-name your-key-name --query 'KeyMaterial' --output text > your-key.pem
```

## 📚 學習資源

- [Terraform 官方文件](https://www.terraform.io/docs)
- [AWS Provider 文件](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform 最佳實踐](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)

## 🤝 貢獻

歡迎提交 Issue 和 Pull Request！

## 📄 授權

MIT License

---

**Happy Terraforming! 🚀**
