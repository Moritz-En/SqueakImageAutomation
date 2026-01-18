#!/usr/bin/env bash
# SWA Squeak Image Setup Script
# Works on macOS, Linux, Windows (Git Bash)

set -e
set -u

INPUT="$1" # Maybe hardcode file
DEST_DIR="${2:-.}"

OS_TYPE="$(uname -s)"

error() {
    echo "Fehler: $1" >&2
    exit 1
}

echo "OS: $OS_TYPE"

case "$OS_TYPE" in
    Darwin*)

        if [ ! -d "$INPUT" ]; then
            error "Needs a Folder"
        fi

        APP_NAME="$(basename "$INPUT")"
        TARGET="/Applications/$APP_NAME"

        sudo cp -R "$INPUT" /Applications/

        sudo xattr -cr "$TARGET"

        ;;

    Linux*|MINGW*|MSYS*|CYGWIN*)

        if [ ! -f "$INPUT" ]; then
            error "Unter Linux/Windows muss eine ZIP-Datei übergeben werden"
        fi

        mkdir -p "$DEST_DIR"
        unzip -o "$INPUT" -d "$DEST_DIR"

        ;;

    *)
        error "unknow OS: $OS_TYPE"
        ;;
esac

echo "Done."
