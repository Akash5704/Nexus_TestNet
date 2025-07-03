# Nexus Network Testnet Dockerfile - Debian Latest
FROM debian:bookworm-slim

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
RUN curl -fsSL https://cli.nexus.xyz/ | sh

# Add nexus binaries to PATH
ENV PATH="/root/.nexus:/root/.nexus/bin:/root/.cargo/bin:${PATH}"

# Set working directory
WORKDIR /app

# Copy startup script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Expose port
EXPOSE 8080

# Set environment variables
ENV NODE_ID=""
ENV RUST_LOG=info

# Start the node
CMD ["./start.sh"]
