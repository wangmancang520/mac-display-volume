#!/bin/sh
set -eu

APP_TARGET="/Applications/Mac Display Volume.app"
DRIVER_TARGET="/Library/Audio/Plug-Ins/HAL/MacDisplayVolumeAudio.driver"

pkill -x DisplayVolume || true
rm -rf "$APP_TARGET"
sudo rm -rf "$DRIVER_TARGET"
sudo killall coreaudiod || true
# Drop the installer receipt left by the .pkg, if any.
sudo pkgutil --forget tech.soit.MacDisplayVolume >/dev/null 2>&1 || true

echo "Removed $APP_TARGET"
echo "Removed $DRIVER_TARGET"
