#!/bin/sh
# Installs a prebuilt release package. Run from the unzipped release folder.
set -eu

PACKAGE_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_PATH="$PACKAGE_DIR/Mac Display Volume.app"
DRIVER_PATH="$PACKAGE_DIR/MacDisplayVolumeAudio.driver"
APP_TARGET="/Applications/Mac Display Volume.app"
DRIVER_TARGET="/Library/Audio/Plug-Ins/HAL/MacDisplayVolumeAudio.driver"

if [ ! -d "$APP_PATH" ] || [ ! -d "$DRIVER_PATH" ]; then
  echo "Run this script from the unzipped release folder." >&2
  exit 1
fi

# Release builds are ad-hoc signed, so clear the download quarantine flag.
xattr -cr "$APP_PATH" "$DRIVER_PATH"

pkill -x DisplayVolume || true
rm -rf "$APP_TARGET"
ditto "$APP_PATH" "$APP_TARGET"

sudo rm -rf "$DRIVER_TARGET"
sudo ditto "$DRIVER_PATH" "$DRIVER_TARGET"
sudo chown -R root:wheel "$DRIVER_TARGET"
sudo killall coreaudiod || true

echo "Installed $APP_TARGET"
echo "Installed $DRIVER_TARGET"
