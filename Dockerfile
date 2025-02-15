# Use a minimal Ubuntu base image
FROM ubuntu:20.04

# Install only necessary dependencies: NASM for Assembly, QEMU for testing
RUN apt-get update && apt-get install -y \
    nasm qemu-system-x86 \
    && rm -rf /var/lib/apt/lists/*

# Set working directory inside container
WORKDIR /app

# Copy scripts into container
COPY scripts/ /app/scripts/

# Ensure scripts are executable
RUN chmod +x /app/scripts/*.sh

# Default entrypoint to prevent permission issues
ENTRYPOINT ["/app/scripts/entrypoint.sh"]
