#!/bin/bash

# start.sh - Nexus Network Testnet Startup Script

set -e

echo "Starting Nexus Network Testnet Node..."
echo "Environment variables:"
echo "NODE_ID: ${NODE_ID:-'NOT SET'}"
echo "RUST_LOG: ${RUST_LOG:-'NOT SET'}"
echo "PORT: ${PORT:-'NOT SET'}"

# Source cargo environment
source ~/.cargo/env

# Source nexus environment if exists
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# Check if NODE_ID is set
if [ -z "$NODE_ID" ]; then
    echo "ERROR: NODE_ID environment variable is not set"
    echo "Please set NODE_ID environment variable with your node ID"
    echo "Available environment variables:"
    env | grep -E "(NODE|NEXUS|RUST)" || echo "No NODE/NEXUS/RUST variables found"
    exit 1
fi

echo "Node ID: $NODE_ID"

# Debug: Check if nexus-network is available
echo "Checking for nexus-network binary..."
which nexus-network || echo "nexus-network not found in PATH"

# Try to find nexus-network in common locations
NEXUS_BINARY=""
for path in /root/.nexus/nexus-network /root/.nexus/bin/nexus-network /usr/local/bin/nexus-network /root/.cargo/bin/nexus-network; do
    if [ -f "$path" ]; then
        NEXUS_BINARY="$path"
        echo "Found nexus-network at: $path"
        break
    fi
done

if [ -z "$NEXUS_BINARY" ]; then
    echo "ERROR: nexus-network binary not found"
    echo "Available files in /root/.nexus/:"
    ls -la /root/.nexus/ || echo "Directory not found"
    echo "Available files in /root/.cargo/bin/:"
    ls -la /root/.cargo/bin/ || echo "Directory not found"
    exit 1
fi

# Start the nexus network node
echo "Starting nexus-network with binary: $NEXUS_BINARY"
exec "$NEXUS_BINARY" start --node-id "$NODE_ID"
