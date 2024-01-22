#!/bin/sh

# Environment variables (without default values)
V2RAY_ADDRESS=${V2RAY_ADDRESS}
V2RAY_PORT=${V2RAY_PORT}
V2RAY_ID=${V2RAY_ID}
V2RAY_PATH=${V2RAY_PATH}

CONFIG_FILE="/etc/v2ray/config.json"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Check required environment variables and exit if they're not all set
if [ -z "$V2RAY_ADDRESS" ] || [ -z "$V2RAY_PORT" ] || [ -z "$V2RAY_ID" ] || [ -z "$V2RAY_PATH" ]; then
    printf "${RED}Error: Environment variables V2RAY_ADDRESS, V2RAY_PORT, V2RAY_ID, and V2RAY_PATH must be set.${NC}\n"
    exit 1
fi

# Print start message
printf "${YELLOW}Starting V2Ray setup...${NC}\n"

# Generate the config file
printf "${YELLOW}Generating V2Ray configuration file...${NC}\n"
cat << EOF > $CONFIG_FILE
{
    "log": {
        "loglevel": "warning"
    },
    "inbounds": [{
        "port": 1080,
        "protocol": "socks",
        "settings": {
            "udp": true
        }
    }],
    "outbounds": [{
        "protocol": "vless",
        "settings": {
            "vnext": [{
                "address": "$V2RAY_ADDRESS",
                "port": $V2RAY_PORT,
                "users": [{
                    "id": "$V2RAY_ID",
                    "encryption": "none"
                }]
            }]
        },
        "streamSettings": {
            "network": "ws",
            "security": "tls",
            "tlsSettings": {
                "serverName": "$V2RAY_ADDRESS",
                "alpn": ["http/1.1"]
            },
            "wsSettings": {
                "path": "$V2RAY_PATH"
            }
        }
    }]
}
EOF

# Confirm configuration file creation
printf "${GREEN}Configuration file generated successfully.${NC}\n"

# Starting V2Ray
printf "${YELLOW}Starting V2Ray with the generated configuration...${NC}\n"
/usr/bin/v2ray run -config "$CONFIG_FILE" &

printf "${YELLOW}Waiting for 5 seconds${NC}\n"
# Wait for a few seconds to ensure V2Ray has started
sleep 5

# Check V2Ray status
printf "${YELLOW}Checking V2Ray operational status...${NC}\n"
if curl --socks5 localhost:1080 -s -o /dev/null http://example.com; then
    printf "${GREEN}Curl success: Successfully fetched the example page via V2Ray.${NC}\n"
else
    printf "${RED}Curl failed: Failed to fetch the example page via V2Ray.${NC}\n"
    exit 1
fi

# Keep the script running to keep the container alive
printf "${YELLOW}V2Ray is now running. Tail-ing logs to keep the container alive...${NC}\n"
tail -f /dev/null
