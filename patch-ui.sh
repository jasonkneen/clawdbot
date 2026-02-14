#!/usr/bin/env bash
set -euo pipefail

# Paths — resolve relative to script location
DEV_ROOT="$(cd "$(dirname "$0")" && pwd)"

# Detect global openclaw installation dynamically
if command -v openclaw &>/dev/null; then
  OPENCLAW_BIN="$(command -v openclaw)"
  # Follow symlink if needed (e.g., npm/pnpm global installs)
  if [ -L "$OPENCLAW_BIN" ]; then
    OPENCLAW_BIN="$(readlink -f "$OPENCLAW_BIN" 2>/dev/null || readlink "$OPENCLAW_BIN")"
  fi
  INSTALLED="$(cd "$(dirname "$OPENCLAW_BIN")/.." && pwd)"
else
  echo "✗ openclaw not found in PATH. Is it installed globally?"
  echo "  Run: npm install -g openclaw  or  pnpm add -g openclaw"
  exit 1
fi

UI_DIR="$DEV_ROOT/ui"
BUILD_OUT="$DEV_ROOT/dist/control-ui"
INSTALL_TARGET="$INSTALLED/dist/control-ui"
BACKUP="$INSTALLED/dist/control-ui.bak"

echo "=== OpenClaw UI Patch ==="
echo ""

# 1. Build
echo "→ Building UI..."
cd "$UI_DIR"
pnpm run build 2>&1 | tail -3
echo ""

# 2. Verify build output
if [ ! -f "$BUILD_OUT/index.html" ]; then
  echo "✗ Build output not found at $BUILD_OUT"
  exit 1
fi
echo "→ Build OK: $(du -sh "$BUILD_OUT" | cut -f1) in $BUILD_OUT"

# 3. Backup installed version (first time only)
if [ ! -d "$BACKUP" ]; then
  echo "→ Backing up installed UI to control-ui.bak..."
  cp -R "$INSTALL_TARGET" "$BACKUP"
else
  echo "→ Backup already exists (control-ui.bak)"
fi

# 4. Patch
echo "→ Patching installed version..."
rm -rf "$INSTALL_TARGET"
cp -R "$BUILD_OUT" "$INSTALL_TARGET"
echo "→ Patched: $(du -sh "$INSTALL_TARGET" | cut -f1)"

# 5. Restart live gateway
echo ""
echo "→ Restarting live gateway..."
cd "$DEV_ROOT"
PID=$(/usr/sbin/lsof -i :18789 -P -t 2>/dev/null | head -1 || true)
if [ -n "$PID" ]; then
  kill "$PID" 2>/dev/null || true
  sleep 2
  echo "  Killed PID $PID"
fi

# Let the system service restart it, or start manually:
# openclaw gateway start
echo ""
echo "=== Done ==="
echo "Live gateway UI patched. Refresh http://127.0.0.1:18789"
echo "To restore: cp -R $BACKUP $INSTALL_TARGET"
