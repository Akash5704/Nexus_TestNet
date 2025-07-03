# Nexus Network Testnet Dockerfile
FROM ubuntu:22.04

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
    curl \
    build-essential \
    pkg-config \
    libssl-dev \
    git \
    protobuf-compiler \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Add RISC-V target
RUN rustup target add riscv32i-unknown-none-elf

# Install Nexus CLI
RUN curl https://cli.nexus.xyz/ | sh

# Make sure nexus is in PATH
ENV PATH="/root/.nexus:${PATH}"

# Set working directory
WORKDIR /app

# Copy startup script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Expose port (adjust if needed)
EXPOSE 8080

# Set environment variables
ENV NODE_ID=""
ENV RUST_LOG=info

# Start the node
CMD ["./start.sh"]