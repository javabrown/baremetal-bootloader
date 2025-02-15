#!/bin/bash
set -e  # Stop on error

echo "🚀 Compiling Bootloader..."

# Ensure output directory exists
mkdir -p /app/bin

# Navigate to source folder before assembling
cd /app/src || exit 1  # ✅ Fix: Ensure we're in the correct directory

# Assemble the bootloader (relative includes should now work)
nasm -f bin bootloader.asm -o /app/bin/bootloader.bin

echo "✅ Bootloader compiled successfully! File saved in bin/bootloader.bin"
