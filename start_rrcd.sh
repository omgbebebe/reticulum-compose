#!/usr/bin/env bash
set -euo pipefail
pushd /opt/rrcd >/dev/null 2>1
source .venv/bin/activate
python -m rrcd "$@"
popd
