#!/bin/bash
set -e  # Stop on error

echo "🚀 Running Bootloader in QEMU..."
qemu-system-x86_64 -drive format=raw,file=/app/bin/bootloader.bin -nographic
