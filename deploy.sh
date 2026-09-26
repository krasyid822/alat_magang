#!/usr/bin/env bash
# Launcher deploy untuk Linux/macOS/Git Bash.
#
# Logika deploy ada di deploy.py — file ini hanya memastikan interpreter
# Python yang benar dipakai lalu meneruskan seluruh argumen.
#
# Contoh:
#   ./deploy.sh          # interaktif, ada konfirmasi
#   ./deploy.sh --yes    # tanpa konfirmasi

set -euo pipefail

cd "$(dirname "$0")"

# Pastikan ada interpreter Python sebelum menjalankan apa pun.
PYTHON=""
for candidate in python3 python; do
  if command -v "$candidate" >/dev/null 2>&1; then
    PYTHON="$candidate"
    break
  fi
done

if [ -z "$PYTHON" ]; then
  echo "❌ Python tidak ditemukan di PATH. Pasang Python 3 lalu ulangi." >&2
  exit 1
fi

exec "$PYTHON" deploy.py "$@"
