#!/usr/bin/env bash
set -euo pipefail
source /opt/rns/.venv/bin/activate
rnsd "$@"
