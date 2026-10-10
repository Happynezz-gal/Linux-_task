#!/usr/bin/env bash
###############################################################################
# setup-mission-workspace.sh
#
# Automates Phases 3-7 of the "Secure File Management & User Configuration"
# lab: directory structure, file creation, listings, copy/remove, permission
# change, and simulated-error recovery.
#
# Must be run as the `agent007` user (NOT root), per the lab's restriction.
###############################################################################

set -euo pipefail

# --- Guard: refuse to run as root ---------------------------------------
if [ "$(id -u)" -eq 0 ]; then
    echo "ERROR: This script must NOT be run as root." >&2
    echo "Log in as 'agent007' first (su - agent007), then re-run this script." >&2
    exit 1
fi

echo "Running as user: $(whoami)"

MISSION_DIR="$HOME/mission"

# --- Phase 3: Workspace directory creation --------------------------------
echo "[Phase 3] Creating directory structure under $MISSION_DIR ..."
mkdir -p "$MISSION_DIR/intel" "$MISSION_DIR/ops/backup"
ls -R "$MISSION_DIR"

# --- Phase 4: File creation and listing ------------------------------------
echo "[Phase 4] Creating intel files and capturing listings ..."
cd "$MISSION_DIR/intel"
touch targets.txt routes.txt keys.txt

ls               > listing1.txt
ls -l            > listing2.txt
ls -la           > listing3.txt

echo "  listing1.txt, listing2.txt, listing3.txt created."

# --- Phase 5: Copy and remove files ----------------------------------------
echo "[Phase 5] Copying routes.txt to backup/, removing keys.txt ..."
cp "$MISSION_DIR/intel/routes.txt" "$MISSION_DIR/ops/backup/"
rm "$MISSION_DIR/intel/keys.txt"

# --- Phase 6: Permissions handling ------------------------------------------
echo "[Phase 6] Setting permissions on targets.txt (owner rw, group r, others none) ..."
chmod 640 "$MISSION_DIR/intel/targets.txt"
ls -l "$MISSION_DIR/intel/targets.txt"

# --- Phase 7: Simulate an error and recover ---------------------------------
echo "[Phase 7] Simulating accidental deletion of backup/routes.txt and recovering ..."
rm "$MISSION_DIR/ops/backup/routes.txt"
cp "$MISSION_DIR/intel/routes.txt" "$MISSION_DIR/ops/backup/"
ls "$MISSION_DIR/ops/backup/"

echo ""
echo "Done. Phases 3-7 complete."
echo "Remaining manual steps:"
echo "  - Phase 8: as root, run: sudo chown root $MISSION_DIR/intel/targets.txt"
echo "             then switch back to agent007 and run: ls -l $MISSION_DIR/intel/targets.txt"
echo "  - Phase 9: run: ls -laR $MISSION_DIR/"
