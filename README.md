# DNS 管理工具

这个仓库包含用于管理 macOS DNS 设置的实用工具，特别用于解决 Cisco VPN 客户端导致的 DNS 问题。

## 问题背景

Cisco AnyConnect VPN 客户端在断开连接后经常不能正确恢复原始 DNS 设置，导致网络连接问题。这些脚本提供了一种简单的方法来管理和恢复 DNS 设置。

## 工具说明

### 1. 基础脚本 (`reset_dns.sh`)

简单的脚本，直接将 DNS 设置为 Google 公共 DNS 服务器 (8.8.8.8 和 8.8.4.4)。

```bash
sudo ./reset_dns.sh
```

### 2. 高级脚本 (`manage_dns.sh`)

功能更强大的脚本，具有多种功能：

#### 命令:

- `current` - 显示当前 DNS 设置
- `save` - 保存当前 DNS 设置
- `reset` - 重置为 Google 公共 DNS
- `restore` - 恢复之前保存的 DNS 设置
- `help` - 显示帮助信息

#### 使用示例:

查看当前 DNS：
```bash
./manage_dns.sh current
```

连接 VPN 前保存 DNS 设置：
```bash
./manage_dns.sh save
```

VPN 断开后修复网络：
```bash
sudo ./manage_dns.sh reset
```

恢复原始 DNS 设置：
```bash
sudo ./manage_dns.sh restore
```

## 安装

克隆此仓库：
```bash
git clone https://github.com/你的用户名/dns-tools.git
cd dns-tools
chmod +x reset_dns.sh manage_dns.sh
```

## 注意事项

- `reset` 和 `restore` 操作需要管理员权限（sudo）
- 这些脚本针对 Wi-Fi 接口设计，如果使用其他网络接口，请修改脚本中相应的接口名称
- DNS 设置会保存在用户主目录下的 `.current_dns_settings` 文件中 