#!/usr/bin/env bash
# Run Genesis on a fresh Mac without git or a clone:
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/connorwforsyth/genesis/main/bootstrap.sh)"
# Downloads the repo to ~/.genesis (replacing any earlier copy) and runs init.sh.
# Arguments are passed through, e.g. `... bootstrap.sh)" -- configure_dock`.
set -euo pipefail

ref="${GENESIS_REF:-main}"
dest="${HOME}/.genesis"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

echo "Downloading Genesis (${ref})..."
curl -fsSL "https://github.com/connorwforsyth/genesis/archive/${ref}.tar.gz" \
  | tar -xz -C "${tmp_dir}" --strip-components 1

rm -rf "${dest}"
mv "${tmp_dir}" "${dest}"
trap - EXIT

exec bash "${dest}/init.sh" "$@"
