#!/bin/bash

# DNS管理脚本
# 用法: ./manage_dns.sh [reset|save|restore]

# 颜色设置
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # 无颜色

# 保存当前DNS配置的文件
DNS_CONFIG_FILE="$HOME/.current_dns_settings"

# 检查是否以root权限运行
check_sudo() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${YELLOW}需要管理员权限运行此命令...${NC}"
    fi
}

# 保存当前DNS设置
save_dns() {
    echo -e "${BLUE}正在保存当前DNS设置...${NC}"
    networksetup -getdnsservers Wi-Fi > "$DNS_CONFIG_FILE"
    echo -e "${GREEN}✅ DNS设置已保存到 $DNS_CONFIG_FILE${NC}"
    echo -e "${YELLOW}当前DNS服务器:${NC}"
    cat "$DNS_CONFIG_FILE"
}

# 恢复保存的DNS设置
restore_dns() {
    if [ ! -f "$DNS_CONFIG_FILE" ]; then
        echo -e "${RED}❌ 没有找到保存的DNS设置${NC}"
        echo -e "${YELLOW}使用 ./manage_dns.sh save 先保存设置${NC}"
        return 1
    fi
    
    # 读取保存的DNS服务器
    DNS_SERVERS=$(cat "$DNS_CONFIG_FILE")
    
    # 检查是否为"There aren't any DNS Servers set"
    if [[ "$DNS_SERVERS" == *"aren't any DNS"* ]]; then
        echo -e "${BLUE}恢复为自动DNS设置...${NC}"
        sudo networksetup -setdnsservers Wi-Fi "Empty"
    else
        echo -e "${BLUE}恢复为以下DNS服务器:${NC}"
        echo "$DNS_SERVERS"
        # 构建命令参数
        CMD="sudo networksetup -setdnsservers Wi-Fi"
        for server in $DNS_SERVERS; do
            CMD="$CMD $server"
        done
        # 执行命令
        eval $CMD
    fi
    
    # 刷新DNS缓存
    sudo dscacheutil -flushcache
    sudo killall -HUP mDNSResponder
    
    echo -e "${GREEN}✅ DNS设置已恢复${NC}"
}

# 重置为Google DNS
reset_dns() {
    echo -e "${BLUE}正在将DNS设置为Google公共DNS...${NC}"
    sudo networksetup -setdnsservers Wi-Fi 8.8.8.8 8.8.4.4
    
    # 刷新DNS缓存
    sudo dscacheutil -flushcache
    sudo killall -HUP mDNSResponder
    
    echo -e "${GREEN}✅ DNS已重置为Google公共DNS服务器${NC}"
    echo -e "${GREEN}⚡ 网络连接应该已恢复正常${NC}"
}

# 显示当前DNS设置
show_current_dns() {
    echo -e "${BLUE}当前DNS服务器:${NC}"
    networksetup -getdnsservers Wi-Fi
}

# 显示帮助信息
show_help() {
    echo -e "${YELLOW}DNS管理脚本${NC}"
    echo "用法: ./manage_dns.sh [命令]"
    echo ""
    echo "命令:"
    echo "  reset    - 重置为Google公共DNS (8.8.8.8, 8.8.4.4)"
    echo "  save     - 保存当前DNS设置"
    echo "  restore  - 恢复之前保存的DNS设置"
    echo "  current  - 显示当前DNS设置"
    echo "  help     - 显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  ./manage_dns.sh save    - 连接VPN前保存DNS设置"
    echo "  ./manage_dns.sh reset   - VPN断开后修复网络问题"
    echo "  ./manage_dns.sh restore - 恢复原始DNS设置"
}

# 主程序
case "$1" in
    reset)
        check_sudo
        reset_dns
        ;;
    save)
        save_dns
        ;;
    restore)
        check_sudo
        restore_dns
        ;;
    current)
        show_current_dns
        ;;
    help|--help|-h|"")
        show_help
        ;;
    *)
        echo -e "${RED}❌ 未知命令: $1${NC}"
        show_help
        exit 1
        ;;
esac

exit 0 