#!/bin/bash
set -e

echo "🔍 Sprawdzanie toolchaina..."
which arm-none-eabi-gcc || { echo "❌ Brak arm-none-eabi-gcc!"; exit 1; }

echo "📦 Ściąganie Klippera..."
rm -rf klipper
git clone https://github.com/Klipper3d/klipper.git
cd klipper
git checkout v0.11.0

echo "🧠 Ładowanie konfiguracji..."
make menuconfig < /dev/null
cat ../klipper.config > .config

echo "🔨 Budowanie Klippera z własną Newlib..."
make clean
make -j$(nproc) \
    NEWLIB_CFLAGS="-nostdlib -isystem \$CONFIG_NEWLIB_BASE/include" \
    NEWLIB_LDFLAGS="-L\$CONFIG_NEWLIB_BASE/lib"

echo "✅ Gotowe. Plik binarny znajduje się w: klipper/out/klipper.bin"
