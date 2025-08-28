#!/bin/bash

echo "🔍 測試 VPC 網路連線"
echo "=================="

echo "📱 1. 測試 Public EC2 的網際網路連線..."
echo "SSH 到 Public EC2:"
echo "ssh -i ./keys/henry-ec2-key.pem ec2-user@<PUBLIC_EC2_IP>"
echo ""
echo "在 Public EC2 中執行:"
echo "curl -I google.com"
echo ""

echo "🔒 2. 測試 Private EC2 的網際網路連線..."
echo "從 Public EC2 SSH 到 Private EC2:"
echo "ssh -i ./keys/henry-ec2-key.pem ec2-user@<PRIVATE_EC2_PRIVATE_IP>"
echo ""
echo "在 Private EC2 中執行:"
echo "curl -I google.com"
echo ""

echo "💡 預期結果:"
echo "- Public EC2 應該能直接存取 google.com"
echo "- Private EC2 應該能透過 NAT Gateway 存取 google.com"
echo "- 外部無法直接 SSH 到 Private EC2"
echo ""

echo "🔧 如果遇到問題:"
echo "1. 檢查 Security Groups 設定"
echo "2. 確認 NAT Gateway 狀態"
echo "3. 檢查 Route Tables 設定"
echo "4. 確認 EC2 實例狀態"
