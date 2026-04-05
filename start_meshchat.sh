#!/usr/bin/env bash
set -euo pipefail
pushd /opt/reticulum-meshchat >/dev/null 2>1
source .venv/bin/activate
python meshchat.py "$@"
popd
