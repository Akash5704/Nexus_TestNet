#!/bin/bash

# start.sh - Nexus Network Testnet Startup Script

set -e

echo "Starting Nexus Network Testnet Node..."

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
    exit 1
fi

echo "Node ID: $NODE_ID"

# Start the nexus network node
exec nexus-network start --node-id "$NODE_ID"