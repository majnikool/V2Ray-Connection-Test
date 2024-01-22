# Use Alpine Linux as the base image for its small footprint
FROM alpine:latest

# Install necessary packages only
RUN apk --no-cache add \
        wget \
        curl \
        ca-certificates \
        libcap \
        && wget https://github.com/v2fly/v2ray-core/releases/download/v5.12.1/v2ray-linux-64.zip \
        && unzip v2ray-linux-64.zip -d /usr/bin/ \
        && chmod +x /usr/bin/v2ray \
        && if [ -f /usr/bin/v2ctl ]; then chmod +x /usr/bin/v2ctl; fi \
        && rm -rf v2ray-linux-64.zip /var/cache/apk/*

# Create a directory for V2Ray configuration and logs
RUN mkdir -p /etc/v2ray /var/log/v2ray

# Expose the port V2Ray listens on
EXPOSE 1080

# Set an environment variable for the default configuration
ENV V2RAY_CONFIG_FILE=/etc/v2ray/config.json

# Copy the start.sh script into the container
COPY start.sh /etc/v2ray/start.sh
RUN chmod +x /etc/v2ray/start.sh

# Set the V2Ray binary as the entrypoint and use the 'run' command
ENTRYPOINT ["/etc/v2ray/start.sh"]
