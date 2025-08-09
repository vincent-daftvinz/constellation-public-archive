#!/usr/bin/env bash
set -euo pipefail

# Run from inside the extracted Constellation_Public_* folder
FOLDER="${1:-.}"

if ! command -v minisign >/dev/null; then
  echo "minisign not found. Install via Homebrew: brew install minisign"
  exit 1
fi

if ! command -v shasum >/dev/null; then
  echo "shasum not found (should exist on macOS)."
  exit 1
fi

cd "$FOLDER"

# Prefer a bundled minisign.pub; fall back to -P if user pastes it
if [[ -f minisign.pub ]]; then
  echo "Verifying signature with minisign.pub..."
  minisign -Vm SHA256SUMS.txt -p minisign.pub
else
  echo "ERROR: minisign.pub is missing. Put your public key file in this folder or edit this script to use -P."
  exit 1
fi

echo "Checking file hashes..."
shasum -a 256 -c SHA256SUMS.txt

echo "✓ Verification complete. All files match."
