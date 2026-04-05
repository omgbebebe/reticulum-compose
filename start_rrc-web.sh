#!/usr/bin/env bash
set -euo pipefail
pushd /opt/rrc-web >/dev/null 2>1
source .venv/bin/activate
./run.sh "$@"
popd
