# scripts/

- [`setup-mission-workspace.sh`](setup-mission-workspace.sh) — automates Phases 3–7 of the
  lab (directory creation, file creation, listings, copy/remove, permissions, and the
  simulated-error recovery). **Run this only after you are logged in as `agent007`** — it
  refuses to run as root. Phase 1 (user creation) and the root half of Phase 8 (ownership
  change) are intentionally left out, since the task requires those to be performed manually
  and observed.

Usage:
```bash
chmod +x setup-mission-workspace.sh
./setup-mission-workspace.sh
```
