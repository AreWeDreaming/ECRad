#!/bin/bash
# Pin the ECRad inter-dependencies to the versions currently set in their own recipes
set -euo pipefail
cd "$(dirname "$0")"
get_version() { sed -nE 's/^\s*version: "([^"]+)"/\1/p' "$1/recipe.yaml" | head -1; }
core=$(get_version ecrad_core)
pylib=$(get_version ecrad_pylib)
sed -i -E "s/^(\s*- ecrad_core)\b.*/\1 >=${core}/" ecrad_pylib/recipe.yaml ecrad_gui/recipe.yaml
sed -i -E "s/^(\s*- ecrad_pylib)\b.*/\1 >=${pylib}/" ecrad_gui/recipe.yaml
