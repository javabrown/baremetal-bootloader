#!/bin/bash
set -e  # Stop on error

echo "🚀 Compiling Bootloader..."

# Ensure output directory exists
mkdir -p /app/bin

# Assemble the bootloader
nasm -f bin /app/src/bootloader.asm -o /app/bin/bootloader.bin

echo "✅ Bootloader compiled successfully! File saved in bin/bootloader.bin"
