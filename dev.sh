#!/usr/bin/env bash
set -e

PORT=${1:-8080}
ROOT="$(cd "$(dirname "$0")/public" && pwd)"

if lsof -iTCP:"$PORT" -sTCP:LISTEN -t >/dev/null 2>&1; then
  echo "Error: port $PORT already in use. Try: ./dev.sh $((PORT+1))"
  exit 1
fi

echo "Serving $ROOT on http://localhost:$PORT"
python3 -m http.server "$PORT" --directory "$ROOT" 2>&1
