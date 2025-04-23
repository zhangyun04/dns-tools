#!/bin/bash

# 重置DNS为Google公共DNS服务器
sudo networksetup -setdnsservers Wi-Fi 8.8.8.8 8.8.4.4

# 刷新DNS缓存
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder

echo "✅ DNS已重置为Google公共DNS服务器"
echo "⚡ 网络连接应该已恢复正常" 