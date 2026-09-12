#!/usr/bin/env bash
# Start clipse as the single clipboard owner.
# Kill persist and any previous clipse wl-paste watchers first.
set -euo pipefail

pkill -x wl-clip-persist 2>/dev/null || true
pkill -f -- --wl-store 2>/dev/null || true
exec clipse -listen
