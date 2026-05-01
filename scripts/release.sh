#!/usr/bin/env bash
set -euo pipefail

# Corvus Player Release Script
# Builds, signs, notarizes, creates ZIP (Sparkle) + DMG (download),
# and optionally publishes a GitHub Release.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
SCHEME="Corvus Player"
APP_NAME="Corvus Player"
ARCHIVE_DIR="/tmp/corvus-release"
APPCAST_FILE="$PROJECT_DIR/docs/appcast.xml"
SIGN_UPDATE=$(find ~/Library/Developer/Xcode/DerivedData -path "*/sparkle/Sparkle/bin/sign_update" -type f 2>/dev/null | head -1)
GITHUB_REPO="CorvusDevs/Corvus-Player"
MIN_SYSTEM_VERSION="14.6"

# Code signing & notarization
SIGNING_IDENTITY="Developer ID Application: Alejandro Estol (52XNM6SN8Q)"
TEAM_ID="52XNM6SN8Q"
KEYCHAIN_PROFILE="corvus-notarize"

usage() {
    cat <<EOF
Usage: $(basename "$0") VERSION [OPTIONS]

Creates a release build of Corvus Player with:
  - Code-signed with Developer ID
  - Notarized by Apple
  - Signed ZIP for Sparkle auto-updates
  - DMG for manual download (stapled)
  - Appcast XML entry

Arguments:
  VERSION    Version number (e.g., 2.1.0)

Options:
  --publish      Create a GitHub Release and upload artifacts
  --skip-build   Skip xcodebuild, use existing archive
  --skip-notarize  Skip notarization (for local testing)
  --help         Show this help

Setup (one-time, already done):
  xcrun notarytool store-credentials "$KEYCHAIN_PROFILE" \\
    --key ~/.appstoreconnect/AuthKey_6QZRV9V47A.p8 \\
    --key-id 6QZRV9V47A --issuer 450f1c71-461c-4fbe-a544-2032408d90f3

Examples:
  $(basename "$0") 2.1.0
  $(basename "$0") 2.1.0 --publish
  $(basename "$0") 2.1.0 --skip-notarize   # local testing
EOF
    exit 0
}

# Parse arguments
VERSION=""
PUBLISH=false
SKIP_BUILD=false
SKIP_NOTARIZE=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --help|-h) usage ;;
        --publish) PUBLISH=true; shift ;;
        --skip-build) SKIP_BUILD=true; shift ;;
        --skip-notarize) SKIP_NOTARIZE=true; shift ;;
        -*) echo "Unknown option: $1"; usage ;;
        *) VERSION="$1"; shift ;;
    esac
done

if [[ -z "$VERSION" ]]; then
    echo "Error: VERSION is required"
    usage
fi

if [[ -z "$SIGN_UPDATE" ]]; then
    echo "Error: Sparkle sign_update tool not found."
    echo "Make sure the Sparkle package is resolved in Xcode."
    exit 1
fi

echo "=== Corvus Player Release v${VERSION} ==="
echo ""

# Clean output directory
rm -rf "$ARCHIVE_DIR"
mkdir -p "$ARCHIVE_DIR"

ARCHIVE_PATH="$ARCHIVE_DIR/$APP_NAME.xcarchive"
APP_PATH="$ARCHIVE_DIR/$APP_NAME.app"
ZIP_NAME="Corvus-Player-${VERSION}.zip"
ZIP_PATH="$ARCHIVE_DIR/$ZIP_NAME"
DMG_NAME="Corvus-Player-${VERSION}.dmg"
DMG_PATH="$ARCHIVE_DIR/$DMG_NAME"

# Step 1: Build archive
if [[ "$SKIP_BUILD" == false ]]; then
    echo ">>> Building archive..."
    xcodebuild archive \
        -project "$PROJECT_DIR/Corvus Player.xcodeproj" \
        -scheme "$SCHEME" \
        -archivePath "$ARCHIVE_PATH" \
        -configuration Release \
        CODE_SIGN_STYLE=Manual \
        CODE_SIGN_IDENTITY="$SIGNING_IDENTITY" \
        DEVELOPMENT_TEAM="$TEAM_ID" \
        CODE_SIGN_INJECT_BASE_ENTITLEMENTS=NO \
        OTHER_CODE_SIGN_FLAGS="--options=runtime" \
        ARCHS=arm64 \
        ONLY_ACTIVE_ARCH=YES \
        ENABLE_USER_SCRIPT_SANDBOXING=NO \
        2>&1 | tail -10
    echo "    Archive created."
else
    echo ">>> Skipping build (--skip-build)"
    if [[ ! -d "$ARCHIVE_PATH" ]]; then
        echo "Error: No archive found at $ARCHIVE_PATH"
        exit 1
    fi
fi

# Step 2: Export .app from archive
echo ">>> Exporting app..."
cp -R "$ARCHIVE_PATH/Products/Applications/$APP_NAME.app" "$APP_PATH"
echo "    App exported to $APP_PATH"

# Step 3: Re-sign embedded dylibs and app (script phase copies dylibs after initial signing)
echo ">>> Re-signing embedded frameworks and dylibs..."
# Sign ALL Mach-O binaries (catches bare files like "Python" without .dylib extension)
find "$APP_PATH/Contents/Frameworks" -type f -print0 2>/dev/null | while IFS= read -r -d '' item; do
    if file -b "$item" | grep -q "Mach-O"; then
        codesign --force --sign "$SIGNING_IDENTITY" --options runtime "$item" 2>/dev/null || true
    fi
done
# Sign framework bundles (nested code — must be signed as a bundle after individual files)
find "$APP_PATH/Contents/Frameworks" -name "*.framework" -type d -print0 2>/dev/null | while IFS= read -r -d '' fw; do
    codesign --force --sign "$SIGNING_IDENTITY" --options runtime "$fw" 2>/dev/null || true
done
# Sign app extensions
find "$APP_PATH/Contents/PlugIns" -name "*.appex" -type d -print0 2>/dev/null | while IFS= read -r -d '' ext; do
    codesign --force --sign "$SIGNING_IDENTITY" --options runtime "$ext"
done
# Sign the main app last
codesign --force --sign "$SIGNING_IDENTITY" --options runtime "$APP_PATH"
echo "    Re-signed."

echo ">>> Verifying code signature..."
codesign --verify --deep --strict "$APP_PATH"
echo "    Signature valid."

# Step 4: Create ZIP for Sparkle
echo ">>> Creating ZIP..."
cd "$ARCHIVE_DIR"
ditto -c -k --sequesterRsrc --keepParent "$APP_NAME.app" "$ZIP_NAME"
ZIP_SIZE=$(stat -f%z "$ZIP_PATH")
echo "    ZIP: $ZIP_NAME ($ZIP_SIZE bytes)"

# Step 5: Create DMG
echo ">>> Creating DMG..."
DMG_STAGING="$ARCHIVE_DIR/dmg-staging"
mkdir -p "$DMG_STAGING"
cp -R "$APP_PATH" "$DMG_STAGING/"
ln -s /Applications "$DMG_STAGING/Applications"

hdiutil create \
    -volname "$APP_NAME" \
    -srcfolder "$DMG_STAGING" \
    -ov -format UDZO \
    "$DMG_PATH" \
    > /dev/null

DMG_SIZE=$(stat -f%z "$DMG_PATH")
echo "    DMG: $DMG_NAME ($DMG_SIZE bytes)"

# Step 6: Notarize
if [[ "$SKIP_NOTARIZE" == false ]]; then
    echo ">>> Submitting DMG for notarization..."
    xcrun notarytool submit "$DMG_PATH" \
        --keychain-profile "$KEYCHAIN_PROFILE" \
        --wait

    echo ">>> Stapling notarization ticket to DMG..."
    xcrun stapler staple "$DMG_PATH"
    echo "    DMG notarized and stapled."

    echo ">>> Submitting ZIP for notarization..."
    xcrun notarytool submit "$ZIP_PATH" \
        --keychain-profile "$KEYCHAIN_PROFILE" \
        --wait

    echo "    ZIP notarized."
    echo ""
    echo "    Note: ZIP cannot be stapled (Sparkle downloads directly)."
    echo "    Gatekeeper will check the notarization ticket online."
else
    echo ">>> Skipping notarization (--skip-notarize)"
fi

# Step 7: Sign ZIP with Sparkle EdDSA
echo ">>> Signing ZIP with Sparkle EdDSA..."
SIGNATURE=$("$SIGN_UPDATE" "$ZIP_PATH" 2>&1 | grep 'sparkle:edSignature=' | sed 's/.*sparkle:edSignature="\([^"]*\)".*/\1/')
if [[ -z "$SIGNATURE" ]]; then
    SIGNATURE=$("$SIGN_UPDATE" "$ZIP_PATH" 2>&1)
    echo "    Raw sign output: $SIGNATURE"
else
    echo "    Signature: ${SIGNATURE:0:20}..."
fi

# Recalculate ZIP size (unchanged, but be explicit)
ZIP_SIZE=$(stat -f%z "$ZIP_PATH")

# Step 8: Generate appcast entry
PUB_DATE=$(date -R)
APPCAST_ENTRY=$(cat <<XMLEOF
        <item>
            <title>Version ${VERSION}</title>
            <description><![CDATA[
                <ul>
                    <li>Update description here</li>
                </ul>
            ]]></description>
            <pubDate>${PUB_DATE}</pubDate>
            <enclosure
                url="https://github.com/${GITHUB_REPO}/releases/download/v${VERSION}/${ZIP_NAME}"
                sparkle:version="${VERSION}"
                sparkle:shortVersionString="${VERSION}"
                length="${ZIP_SIZE}"
                type="application/octet-stream"
                sparkle:edSignature="${SIGNATURE}"
            />
            <sparkle:minimumSystemVersion>${MIN_SYSTEM_VERSION}</sparkle:minimumSystemVersion>
        </item>
XMLEOF
)

echo ""
echo "=== Appcast Entry ==="
echo "$APPCAST_ENTRY"
echo ""

echo "$APPCAST_ENTRY" > "$ARCHIVE_DIR/appcast-entry.xml"

# Step 9: Publish (optional)
if [[ "$PUBLISH" == true ]]; then
    if ! command -v gh &> /dev/null; then
        echo "Error: 'gh' CLI not found. Install with: brew install gh"
        exit 1
    fi

    echo ">>> Creating GitHub Release v${VERSION}..."
    gh release create "v${VERSION}" \
        --repo "$GITHUB_REPO" \
        --title "Corvus Player ${VERSION}" \
        --notes "## What's New

- Update description here

## Download

- **[Corvus-Player-${VERSION}.dmg](https://github.com/${GITHUB_REPO}/releases/download/v${VERSION}/${DMG_NAME})** — Drag to Applications
- Auto-update via Sparkle for existing users" \
        "$ZIP_PATH" \
        "$DMG_PATH"

    echo "    Release created!"
    echo ""
    echo ">>> Updating appcast.xml..."
    sed -i '' "s|    </channel>|${APPCAST_ENTRY}\n    </channel>|" "$APPCAST_FILE"
    echo "    Appcast updated."
    echo ""
    echo "Don't forget to commit and push docs/appcast.xml:"
    echo "  git add docs/appcast.xml"
    echo "  git commit -m 'Release v${VERSION} appcast'"
    echo "  git push"
else
    echo "=== Next Steps ==="
    echo ""
    echo "  1. Create GitHub Release:"
    echo "     gh release create v${VERSION} --repo ${GITHUB_REPO} \\"
    echo "       --title 'Corvus Player ${VERSION}' \\"
    echo "       '$ZIP_PATH' '$DMG_PATH'"
    echo ""
    echo "  2. Add appcast entry to $APPCAST_FILE"
    echo "     (saved to $ARCHIVE_DIR/appcast-entry.xml)"
    echo ""
    echo "  3. Commit and push:"
    echo "     git add docs/appcast.xml && git commit -m 'Release v${VERSION}' && git push"
fi

echo ""
echo "=== Artifacts ==="
echo "  ZIP: $ZIP_PATH"
echo "  DMG: $DMG_PATH"
echo "  Appcast entry: $ARCHIVE_DIR/appcast-entry.xml"
echo ""
echo "Done!"
