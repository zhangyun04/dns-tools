#!/bin/bash

# Reset DNS to Google public DNS servers
sudo networksetup -setdnsservers Wi-Fi 8.8.8.8 8.8.4.4

# Flush DNS cache
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder

echo "✅ DNS has been reset to Google public DNS servers"
echo "⚡ Network connection should be restored" 