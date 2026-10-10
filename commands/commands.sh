#!/usr/bin/env bash
###############################################################################
# commands.sh
#
# Reference list of every command used in the
# "Secure File Management & User Configuration on Kali Linux" lab, in order.
#
# IMPORTANT: This script is a REFERENCE, not meant to be run start-to-finish
# unattended — it deliberately switches from root/sudo to the `agent007` user
# partway through (Phase 2) and back to root briefly (Phase 8). Read and run
# it phase by phase in an interactive terminal.
###############################################################################

set -e

###############################################################################
# PHASE 1 — Create the new user (run as: root / sudo)
###############################################################################
sudo useradd -m -s /bin/bash -G sudo agent007
sudo passwd agent007                 # sets the password interactively
id agent007                          # verify: uid, gid, and sudo group membership

###############################################################################
# PHASE 2 — Switch to the new user (run as: root -> agent007)
###############################################################################
su - agent007
whoami                                # verify: should print "agent007"

###############################################################################
# From here on, every command runs as agent007
# (except the single chown step in Phase 8, marked below)
###############################################################################

###############################################################################
# PHASE 3 — Build the workspace directory structure
###############################################################################
mkdir -p ~/mission/intel ~/mission/ops/backup
cd ~/mission
ls -R ~/mission                       # verify structure

###############################################################################
# PHASE 4 — Create files and capture listings
###############################################################################
cd ~/mission/intel
touch targets.txt routes.txt keys.txt

ls               > listing1.txt
ls -l            > listing2.txt
ls -la           > listing3.txt

cat listing1.txt
cat listing2.txt
cat listing3.txt

###############################################################################
# PHASE 5 — Copy and remove files
###############################################################################
cp ~/mission/intel/routes.txt ~/mission/ops/backup/
ls ~/mission/ops/backup/              # verify: routes.txt present

rm ~/mission/intel/keys.txt
ls ~/mission/intel/                   # verify: keys.txt gone

###############################################################################
# PHASE 6 — Permissions handling
###############################################################################
# Owner: read+write, Group: read only, Others: none  ==  rw-r-----  ==  640
chmod 640 ~/mission/intel/targets.txt
ls -l ~/mission/intel/targets.txt     # verify: -rw-r-----

###############################################################################
# PHASE 7 — Simulate an error and recover
###############################################################################
rm ~/mission/ops/backup/routes.txt              # simulated accidental deletion
ls ~/mission/ops/backup/                        # verify: empty

cp ~/mission/intel/routes.txt ~/mission/ops/backup/   # recovery
ls ~/mission/ops/backup/                        # verify: routes.txt restored

###############################################################################
# PHASE 8 — Advanced permissions & ownership
###############################################################################
# --- run as root ---
# exit                                 # (exit back to root shell, or open a new root shell)
# sudo chown root /home/agent007/mission/intel/targets.txt
# exit                                 # return to agent007

# --- back as agent007 ---
# su - agent007
ls -l ~/mission/intel/targets.txt     # observe: owner is now root

###############################################################################
# PHASE 9 — Evidence collection & final verification
###############################################################################
ls -laR ~/mission/ | tee ~/mission-final-listing.txt
history > ~/command-history.txt
