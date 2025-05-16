#!/bin/bash
set -e

echo "🔍 Sprawdzanie toolchaina..."
which arm-none-eabi-gcc || { echo "❌ Brak arm-none-eabi-gcc!"; exit 1; }

echo "📦 Ściąganie Klippera..."
git clone https://github.com/Klipper3d/klipper.git
cd klipper

echo "🧠 Ładowanie konfiguracji..."
cat <<EOF > .config
# CONFIGURATION: BTT SKR MINI E3 V2.0 with UART (Nebula Pad)
CONFIG_MCU="stm32f103"
CONFIG_MCU_STM32=y
CONFIG_MCU_STM32F1=y
CONFIG_STM32F103=y
CONFIG_STM32_CLOCK_REF_8M=y
CONFIG_FLASH_START=0x08000000
CONFIG_FLASH_SIZE=0x10000
CONFIG_RAM_START=0x20000000
CONFIG_RAM_SIZE=0x5000
CONFIG_CLOCK_FREQ=72000000
CONFIG_SERIAL_PORT=1
CONFIG_BAUD_RATE=250000
CONFIG_HAVE_NEWLIB=y
CONFIG_NEWLIB_BASE="/__w/klipper-builder/klipper-builder/newlib"
EOF

echo "🔨 Budowanie Klippera z własną Newlib..."
make -j$(nproc) \
    NEWLIB_CFLAGS="-nostdlib -isystem \$CONFIG_NEWLIB_BASE/include" \
    NEWLIB_LDFLAGS="-L\$CONFIG_NEWLIB_BASE/lib"

echo "✅ Gotowe. Plik binarny w: out/klipper.bin"
