#!/bin/bash

# DNS Management Script
# Usage: ./manage_dns.sh [reset|save|restore]

# Color settings
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# File to save current DNS configuration
DNS_CONFIG_FILE="$HOME/.current_dns_settings"

# Check if running with root privileges
check_sudo() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${YELLOW}Administrator privileges required for this command...${NC}"
    fi
}

# Save current DNS settings
save_dns() {
    echo -e "${BLUE}Saving current DNS settings...${NC}"
    networksetup -getdnsservers Wi-Fi > "$DNS_CONFIG_FILE"
    echo -e "${GREEN}✅ DNS settings saved to $DNS_CONFIG_FILE${NC}"
    echo -e "${YELLOW}Current DNS servers:${NC}"
    cat "$DNS_CONFIG_FILE"
}

# Restore saved DNS settings
restore_dns() {
    if [ ! -f "$DNS_CONFIG_FILE" ]; then
        echo -e "${RED}❌ No saved DNS settings found${NC}"
        echo -e "${YELLOW}Use ./manage_dns.sh save to save settings first${NC}"
        return 1
    fi
    
    # Read saved DNS servers
    DNS_SERVERS=$(cat "$DNS_CONFIG_FILE")
    
    # Check if it's "There aren't any DNS Servers set"
    if [[ "$DNS_SERVERS" == *"aren't any DNS"* ]]; then
        echo -e "${BLUE}Restoring to automatic DNS settings...${NC}"
        sudo networksetup -setdnsservers Wi-Fi "Empty"
    else
        echo -e "${BLUE}Restoring to the following DNS servers:${NC}"
        echo "$DNS_SERVERS"
        # Build command arguments
        CMD="sudo networksetup -setdnsservers Wi-Fi"
        for server in $DNS_SERVERS; do
            CMD="$CMD $server"
        done
        # Execute command
        eval $CMD
    fi
    
    # Flush DNS cache
    sudo dscacheutil -flushcache
    sudo killall -HUP mDNSResponder
    
    echo -e "${GREEN}✅ DNS settings have been restored${NC}"
}

# Reset to Google DNS
reset_dns() {
    echo -e "${BLUE}Setting DNS to Google public DNS...${NC}"
    sudo networksetup -setdnsservers Wi-Fi 8.8.8.8 8.8.4.4
    
    # Flush DNS cache
    sudo dscacheutil -flushcache
    sudo killall -HUP mDNSResponder
    
    echo -e "${GREEN}✅ DNS has been reset to Google public DNS servers${NC}"
    echo -e "${GREEN}⚡ Network connection should be restored${NC}"
}

# Show current DNS settings
show_current_dns() {
    echo -e "${BLUE}Current DNS servers:${NC}"
    networksetup -getdnsservers Wi-Fi
}

# Show help information
show_help() {
    echo -e "${YELLOW}DNS Management Script${NC}"
    echo "Usage: ./manage_dns.sh [command]"
    echo ""
    echo "Commands:"
    echo "  reset    - Reset to Google public DNS (8.8.8.8, 8.8.4.4)"
    echo "  save     - Save current DNS settings"
    echo "  restore  - Restore previously saved DNS settings"
    echo "  current  - Show current DNS settings"
    echo "  help     - Show this help information"
    echo ""
    echo "Examples:"
    echo "  ./manage_dns.sh save    - Save DNS settings before connecting to VPN"
    echo "  ./manage_dns.sh reset   - Fix network issues after VPN disconnection"
    echo "  ./manage_dns.sh restore - Restore original DNS settings"
}

# Main program
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
        echo -e "${RED}❌ Unknown command: $1${NC}"
        show_help
        exit 1
        ;;
esac

exit 0 