#!/usr/bin/env bash
set -euo pipefail

# Sync agent markdown files from this repo to Claude's local agents directory.
# It detects whether agents live at repo root or in an agents/ subdirectory.
# Usage:
#   ./sync-agents.sh                 # sync to default: $HOME/.claude/agents
#   ./sync-agents.sh /custom/dir     # sync to a custom destination

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -d "${SCRIPT_DIR}/agents" ]]; then
  SRC_DIR="${SCRIPT_DIR}/agents"
else
  SRC_DIR="${SCRIPT_DIR}"
fi
DEST_DIR="${1:-"${HOME}/.claude/agents"}"

echo "Using source directory: ${SRC_DIR}"

mkdir -p "${DEST_DIR}"

echo "Syncing agents from: ${SRC_DIR}" \
  && echo "               to: ${DEST_DIR}" \
  && echo

if command -v rsync >/dev/null 2>&1; then
  # Include only markdown files while preserving directory structure;
  # exclude repository-level files that shouldn't be synced as agents
  rsync -av \
    --include '*/' \
    --include '*.md' \
    --exclude 'README.md' \
    --exclude 'LICENSE' \
    --exclude '.git*' \
    --exclude '*.sh' \
    --exclude '*' \
    "${SRC_DIR}/" "${DEST_DIR}/"
else
  echo "rsync not found; falling back to cp" >&2
  copied=0
  # Copy only .md files from top-level of agents and any subdirectories
  while IFS= read -r -d '' file; do
    rel_path="${file#${SRC_DIR}/}"
    dest_path_dir="${DEST_DIR}/$(dirname "${rel_path}")"
    mkdir -p "${dest_path_dir}"
    base_name="$(basename "${file}")"
    if [[ "${base_name}" == "README.md" ]]; then continue; fi
    cp -f "${file}" "${dest_path_dir}/"
    copied=$((copied + 1))
  done < <(find "${SRC_DIR}" -type f -name '*.md' -not -name 'README.md' -print0)
  echo "Copied ${copied} files to ${DEST_DIR}"
fi

echo "Done. Agents are now available in: ${DEST_DIR}"