# README for V2Ray Connection Test Docker Container

## Overview
This Docker container is specifically designed for testing the connectivity of a V2Ray proxy in a selected network environment. It simplifies the process of checking if a V2Ray connection is properly configured and operational.

## Prerequisites
Ensure Docker is installed and running on your system.

## Quick Start

1. **Run the Container**  
   Execute the following command, replacing the `x.x.x` and `x-x-x-x-x` placeholders with your actual V2Ray server configuration.

    ```bash
    docker run -d -p 1080:1080 \
      -e V2RAY_ADDRESS=x.x.x \
      -e V2RAY_PORT=443 \
      -e V2RAY_ID=x-x-x-x-x \
      -e V2RAY_PATH=/x \
      --name v2ray-test-container majidni/myapp:1
    ```

    Explanation of parameters:
    - `-d`: Run the container in detached mode.
    - `-p 1080:1080`: Map port 1080 of the host to port 1080 of the container.
    - `-e`: Set environment variables (V2RAY_ADDRESS, V2RAY_PORT, V2RAY_ID, V2RAY_PATH) for the V2Ray configuration.
    - `--name`: Name your container for easier reference.

2. **Check the Container's Status**  
   Use `docker ps` to ensure your container is running.

## Container Configuration
- **Base Image**: Alpine Linux, chosen for its small footprint.
- **Exposed Ports**: Port 1080 is exposed for testing the V2Ray connection.
- **Configuration**: The `start.sh` script auto-generates the V2Ray configuration (`config.json`) based on provided environment variables and runs connectivity tests.

## Connectivity Testing Process
The `start.sh` script in the container performs the following:
- Validates the presence of essential environment variables (V2RAY_ADDRESS, V2RAY_PORT, V2RAY_ID, V2RAY_PATH).
- Generates the `config.json` file for V2Ray based on the provided configuration.
- Starts the V2Ray service in the background.
- Executes a connectivity test using `curl` to ensure the V2Ray proxy is routing traffic properly.
- Keeps the container alive to allow for continuous testing and monitoring.

## Troubleshooting
If the connection test fails, consider the following:
- Ensure all environment variables are correctly set.
- Verify that the V2Ray server details (address, port, ID, path) are accurate.
- Review the container's logs for error messages or clues: `docker logs v2ray-test-container`.

## Conclusion
This Docker container offers a streamlined and isolated environment for testing V2Ray connections, simplifying the process of verifying proxy functionality in different network setups.