#!/usr/bin/env bash
set -e
set -u

INPUT="$1"  # hardcode name

OS_TYPE="$(uname -s)"

error() { echo "Fehler: $1" >&2; exit 1; }

case "$OS_TYPE" in
    Darwin*)
     
        TMP_DIR="/tmp/SWA_tmp"
        mkdir -p "$TMP_DIR"

        if [[ "$INPUT" == *.zip ]]; then
            unzip -o "$INPUT" -d "$TMP_DIR"
            APP_PATH=$(find "$TMP_DIR" -name "*.app" -type d | head -n1)
            [ -z "$APP_PATH" ] && error "no .app found"
        else
            [ ! -d "$INPUT" ] && error "Ordner does not exist"
            APP_PATH=$(find "$INPUT" -name "*.app" -type d | head -n1)
            [ -z "$APP_PATH" ] && error ".app not found"
        fi

        APP_NAME=$(basename "$APP_PATH")
        TARGET="/Applications/$APP_NAME"

        sudo cp -R "$APP_PATH" /Applications/

        sudo xattr -cr "$TARGET" || true

        ;;

    Linux*|MINGW*|MSYS*|CYGWIN*)

        [ ! -f "$INPUT" ] && error ".zip required"

        DEST_DIR="${2:-.}"
        mkdir -p "$DEST_DIR"
        unzip -o "$INPUT" -d "$DEST_DIR"
        ;;

    *)
        error "Unknown OS: $OS_TYPE"
        ;;
esac

echo "Done."
