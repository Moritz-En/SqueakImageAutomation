#!/usr/bin/env bash
# new SqueakImage generator mit automatischer macOS-Installation

set -e
set -u

ZIP_FILE="$1" #Change to zip name
DEST_DIR="${2:-.}"

if [ ! -f "$ZIP_FILE" ]; then
    echo "Fehler: ZIP-Datei '$ZIP_FILE' existiert nicht."
    exit 1
fi

mkdir -p "$DEST_DIR"

OS_TYPE="$(uname -s)"

case "$OS_TYPE" in
    Linux*)
        unzip -o "$ZIP_FILE" -d "$DEST_DIR"
        ;;
    Darwin*)
        unzip -o "$ZIP_FILE" -d "$DEST_DIR"

        find "$DEST_DIR" -type f -name "*.sh" -exec chmod +x {} \;

        APP_PATH="$DEST_DIR/SWA2025.app"
        if [ -d "$APP_PATH" ]; then
            sudo mv "$APP_PATH" /Applications/
            sudo xattr -cr /Applications/SWA2025.app
        else
            echo "⚠️ Hinweis: SWA2025.app nicht gefunden, bitte manuell verschieben."
        fi
        ;;
    MINGW*|MSYS*|CYGWIN*)
        unzip -o "$ZIP_FILE" -d "$DEST_DIR"
        ;;
    *)
        exit 1
        ;;
esac

echo "Done."
