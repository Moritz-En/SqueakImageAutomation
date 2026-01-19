# SWA Squeak Image – Setup

This repository contains a cross-platform setup script for the SWA Squeak Image.
It supports **macOS**, **Linux**, and **Windows (Git Bash)**.

---

## Quick Start



```bash
chmod +x newSqueakImage.sh
./newSqueakImage.sh SWA2025-v4.zip
```
change zip file


macOs possible error fix
```
sed -i '' 's/\r$//' newSqueakImage.sh
```
