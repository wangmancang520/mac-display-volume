#!/bin/sh
# Builds Build/MacDisplayVolume-<version>.pkg containing the app and HAL driver.
# Set SKIP_BUILD=1 to package the existing Build/ and Driver/Build/ outputs.
set -eu

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_DIR="$ROOT_DIR/Build"
APP_PATH="$BUILD_DIR/Mac Display Volume.app"
DRIVER_PATH="$ROOT_DIR/Driver/Build/MacDisplayVolumeAudio.driver"
INSTALLER_DIR="$ROOT_DIR/Installer"
PKG_ID="tech.soit.MacDisplayVolume"

if [ "${SKIP_BUILD:-0}" != "1" ]; then
  "$ROOT_DIR/Scripts/build-app.sh" >/dev/null
  "$ROOT_DIR/Scripts/build-driver.sh" >/dev/null
fi

VERSION="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$APP_PATH/Contents/Info.plist")"
WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

PAYLOAD_DIR="$WORK_DIR/payload"
mkdir -p "$PAYLOAD_DIR/Applications" "$PAYLOAD_DIR/Library/Audio/Plug-Ins/HAL"
ditto "$APP_PATH" "$PAYLOAD_DIR/Applications/Mac Display Volume.app"
ditto "$DRIVER_PATH" "$PAYLOAD_DIR/Library/Audio/Plug-Ins/HAL/MacDisplayVolumeAudio.driver"
xattr -cr "$PAYLOAD_DIR"

# Always install to /Applications instead of relocating onto an existing copy.
COMPONENT_PLIST="$WORK_DIR/component.plist"
pkgbuild --analyze --root "$PAYLOAD_DIR" "$COMPONENT_PLIST" >/dev/null
INDEX=0
while /usr/libexec/PlistBuddy -c "Print :$INDEX" "$COMPONENT_PLIST" >/dev/null 2>&1; do
  /usr/libexec/PlistBuddy -c "Set :$INDEX:BundleIsRelocatable false" "$COMPONENT_PLIST" 2>/dev/null ||
    /usr/libexec/PlistBuddy -c "Add :$INDEX:BundleIsRelocatable bool false" "$COMPONENT_PLIST"
  INDEX=$((INDEX + 1))
done

COPYFILE_DISABLE=1 pkgbuild \
  --root "$PAYLOAD_DIR" \
  --component-plist "$COMPONENT_PLIST" \
  --scripts "$INSTALLER_DIR/scripts" \
  --identifier "$PKG_ID" \
  --version "$VERSION" \
  --install-location / \
  "$WORK_DIR/MacDisplayVolume-component.pkg" >/dev/null

cat > "$WORK_DIR/distribution.xml" <<XML
<?xml version="1.0" encoding="utf-8"?>
<installer-gui-script minSpecVersion="2">
  <title>Mac Display Volume $VERSION</title>
  <welcome file="welcome.html"/>
  <license file="LICENSE"/>
  <options customize="never" require-scripts="true" hostArchitectures="arm64"/>
  <domains enable_anywhere="false" enable_currentUserHome="false" enable_localSystem="true"/>
  <volume-check>
    <allowed-os-versions>
      <os-version min="15.0"/>
    </allowed-os-versions>
  </volume-check>
  <choices-outline>
    <line choice="default"/>
  </choices-outline>
  <choice id="default" title="Mac Display Volume">
    <pkg-ref id="$PKG_ID"/>
  </choice>
  <pkg-ref id="$PKG_ID" version="$VERSION" onConclusion="none">MacDisplayVolume-component.pkg</pkg-ref>
</installer-gui-script>
XML

RESOURCES_DIR="$WORK_DIR/resources"
cp -R "$INSTALLER_DIR/resources" "$RESOURCES_DIR"
cp "$ROOT_DIR/LICENSE" "$RESOURCES_DIR/LICENSE"

OUTPUT_PATH="$BUILD_DIR/MacDisplayVolume-$VERSION.pkg"
# Set INSTALLER_SIGN_IDENTITY to a "Developer ID Installer" identity to sign.
set -- \
  --distribution "$WORK_DIR/distribution.xml" \
  --resources "$RESOURCES_DIR" \
  --package-path "$WORK_DIR"
if [ -n "${INSTALLER_SIGN_IDENTITY:-}" ]; then
  set -- "$@" --sign "$INSTALLER_SIGN_IDENTITY"
fi
productbuild "$@" "$OUTPUT_PATH" >/dev/null

echo "$OUTPUT_PATH"
