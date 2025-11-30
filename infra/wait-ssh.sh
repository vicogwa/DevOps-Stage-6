#!/bin/bash

SERVER_IP=$1
KEY_PATH=$2
MAX_ATTEMPTS=60
ATTEMPT=1

if [ -z "$SERVER_IP" ] || [ -z "$KEY_PATH" ]; then
    echo "Usage: $0 <server_ip> <key_path>"
    exit 1
fi

echo "Waiting for SSH connection to $SERVER_IP..."

while [ $ATTEMPT -le $MAX_ATTEMPTS ]; do
    echo "Attempt $ATTEMPT/$MAX_ATTEMPTS..."
    
    if ssh -i "$KEY_PATH" -o ConnectTimeout=10 -o StrictHostKeyChecking=no ubuntu@"$SERVER_IP" "echo 'SSH connection successful'" 2>/dev/null; then
        echo "SSH connection established successfully!"
        exit 0
    fi
    
    sleep 10
    ATTEMPT=$((ATTEMPT + 1))
done

echo "Failed to establish SSH connection after $MAX_ATTEMPTS attempts"
exit 1