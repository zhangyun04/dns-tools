# DNS Management Tools

This repository contains utilities for managing macOS DNS settings, specifically for resolving DNS issues caused by Cisco VPN clients.

## Background

Cisco AnyConnect VPN clients often fail to correctly restore the original DNS settings after disconnecting, causing network connectivity issues. These scripts provide a simple way to manage and restore DNS settings.

## Tools Description

### 1. Basic Script (`reset_dns.sh`)

A simple script that directly sets DNS to Google's public DNS servers (8.8.8.8 and 8.8.4.4).

```bash
sudo ./reset_dns.sh
```

### 2. Advanced Script (`manage_dns.sh`)

A more powerful script with multiple functions:

#### Commands:

- `current` - Display current DNS settings
- `save` - Save current DNS settings
- `reset` - Reset to Google's public DNS
- `restore` - Restore previously saved DNS settings
- `help` - Display help information

#### Usage Examples:

View current DNS:
```bash
./manage_dns.sh current
```

Save DNS settings before connecting to VPN:
```bash
./manage_dns.sh save
```

Fix network after VPN disconnection:
```bash
sudo ./manage_dns.sh reset
```

Restore original DNS settings:
```bash
sudo ./manage_dns.sh restore
```

## Installation

Clone this repository:
```bash
git clone https://github.com/yourusername/dns-tools.git
cd dns-tools
chmod +x reset_dns.sh manage_dns.sh
```

## Notes

- `reset` and `restore` operations require administrator privileges (sudo)
- These scripts are designed for Wi-Fi interface, modify the interface name in the scripts if you use a different network interface
- DNS settings are saved in the `.current_dns_settings` file in your home directory 