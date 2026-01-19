#!/usr/bin/env bash
set -e
set -u

INPUT="$1"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_NAME="$(basename "$0")"
OS_TYPE="$(uname -s)"
DEST_DIR="${2:-$SCRIPT_DIR}"

# Funktion zum Kopieren von allen Ordnern, die mit 'swa' beginnen
copy_swa_resources() {
    local src="$1"
    local dst="$2"
    mkdir -p "$dst"
    shopt -s nullglob 2>/dev/null || true
    for d in "$src"/swa*; do
        [ -d "$d" ] || continue
        rm -rf "$dst/$(basename "$d")"
        cp -R "$d" "$dst/"
    done
    shopt -u nullglob 2>/dev/null || true
}

# 1. Alte .app finden und swa* sichern
OLD_APP="$(find "$SCRIPT_DIR" -maxdepth 1 -type d -name "*.app" | head -n1)"
SWA_TMP="$SCRIPT_DIR/swa_tmp"
mkdir -p "$SWA_TMP"

if [ -d "$OLD_APP" ]; then
    RESOURCES="$OLD_APP/Contents/Resources"
    copy_swa_resources "$RESOURCES" "$SWA_TMP"
fi

# 2. Alte .app und alte Scripts, .bat löschen
find "$SCRIPT_DIR" -maxdepth 1 \
    \( -type f -name "*.sh" -o -type f -name "*.bat" -o -type d -name "*.app" \) \
    ! -name "$SCRIPT_NAME" \
    -exec rm -rf {} +

# 3. Neue Version bereitstellen
case "$OS_TYPE" in
    Darwin*|Linux*|MINGW*|MSYS*|CYGWIN*)
        if [ -f "$INPUT" ]; then
            mkdir -p "$DEST_DIR"
            unzip -o "$INPUT" -d "$DEST_DIR"
            APP_PATH="$(find "$DEST_DIR" -maxdepth 1 -type d -name "*.app" | head -n1)"
        elif [ -d "$INPUT" ]; then
            cp -R "$INPUT" "$DEST_DIR/"
            APP_PATH="$DEST_DIR/$(basename "$INPUT")"
        else
            echo "Input not found: $INPUT"
            exit 1
        fi
        ;;
    *)
        echo "Unsupported OS: $OS_TYPE"
        exit 1
        ;;
esac

# 4. Alle swa*-Ordner wieder in die neue .app/Contents/Resources kopieren
RESOURCES="$APP_PATH/Contents/Resources"
copy_swa_resources "$SWA_TMP" "$RESOURCES"

# 5. macOS Gatekeeper fix
[[ "$OS_TYPE" == Darwin* ]] && sudo xattr -cr "$APP_PATH"

echo "Temporary swa* backup kept at: $SWA_TMP"
echo "New .app ready at: $APP_PATH"
