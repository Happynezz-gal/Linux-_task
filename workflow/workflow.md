# Detailed Workflow — Secure File Management & User Configuration

Each phase below states **who** runs the commands (root/sudo vs. `agent007`), **what** to
run, **what to expect**, **how to verify it**, and **what evidence to capture**.

---

## Phase 1 — Account Creation (run as: `root` / `sudo`)

**Goal:** Create the `agent007` account correctly, since this is the only phase allowed to
run with elevated privileges (along with `usermod` if needed later).

| Step | Command | Expected Result | Verify | Evidence |
|---|---|---|---|---|
| 1.1 | `sudo useradd -m -s /bin/bash -G sudo agent007` | User created with a home directory and bash shell, added to `sudo` group | `id agent007` | Terminal output of `id agent007` → save to `evidence/terminal-output/` |
| 1.2 | `sudo passwd agent007` | Prompts for and sets a new password | Successful "password updated" message | Screenshot (do **not** capture the password itself) |

> **Note:** `useradd` and `usermod` are the *only* commands in this entire lab that are
> permitted to run as root/sudo. Everything from Phase 2 onward must run as `agent007`.

---

## Phase 2 — Switch to `agent007` (run as: `root` → `agent007`)

| Step | Command | Expected Result | Verify | Evidence |
|---|---|---|---|---|
| 2.1 | `su - agent007` | Shell prompt changes to reflect the new user (e.g. `agent007@kali:~$`) | `whoami` returns `agent007` | Screenshot of prompt/`whoami` |

From this point forward, **all commands run as `agent007`** unless explicitly marked
otherwise (Phase 8 has one root step).

---

## Phase 3 — Workspace Directory Creation (run as: `agent007`)

**Goal:** Build the required directory tree under the user's home directory.

```
/home/agent007/mission/
├── intel/
└── ops/
    └── backup/
```

| Step | Command | Expected Result | Verify | Evidence |
|---|---|---|---|---|
| 3.1 | `mkdir -p ~/mission/intel ~/mission/ops/backup` | Full tree created in one command | `ls -R ~/mission` | Terminal output |
| 3.2 | `cd ~/mission` | Working directory changes | `pwd` shows `/home/agent007/mission` | — |

---

## Phase 4 — File Creation and Listing (run as: `agent007`)

**Goal:** Create the three intel files and capture three different `ls` listing styles.

| Step | Command | Expected Result | Verify | Evidence |
|---|---|---|---|---|
| 4.1 | `cd ~/mission/intel && touch targets.txt routes.txt keys.txt` | Three empty files created | `ls` shows all three | — |
| 4.2 | `ls > listing1.txt` | Plain filenames captured | `cat listing1.txt` | `listing1.txt` saved inside `intel/` |
| 4.3 | `ls -l > listing2.txt` | Long-format listing (permissions, owner, size, date) captured | `cat listing2.txt` | `listing2.txt` saved inside `intel/` |
| 4.4 | `ls -la > listing3.txt` | Long format **including hidden files** captured | `cat listing3.txt` | `listing3.txt` saved inside `intel/` |

---

## Phase 5 — Copy and Remove Files (run as: `agent007`)

| Step | Command | Expected Result | Verify | Evidence |
|---|---|---|---|---|
| 5.1 | `cp ~/mission/intel/routes.txt ~/mission/ops/backup/` | `routes.txt` now exists in both `intel/` and `ops/backup/` | `ls ~/mission/ops/backup/` | Terminal output |
| 5.2 | `rm ~/mission/intel/keys.txt` | `keys.txt` removed from `intel/` | `ls ~/mission/intel/` (no `keys.txt`) | Terminal output |

---

## Phase 6 — Permissions Handling (run as: `agent007`)

**Goal:** Set `targets.txt` to owner `rw`, group `r`, others `none` (numeric: `640`).

| Step | Command | Expected Result | Verify | Evidence |
|---|---|---|---|---|
| 6.1 | `chmod 640 ~/mission/intel/targets.txt` (equivalently `chmod u=rw,g=r,o= targets.txt`) | Permission string becomes `-rw-r-----` | `ls -l ~/mission/intel/targets.txt` | Screenshot / terminal output showing `-rw-r-----` |

---

## Phase 7 — Simulate an Error and Recover (run as: `agent007`)

**Goal:** Practice basic disaster recovery for an accidentally deleted file.

| Step | Command | Expected Result | Verify | Evidence |
|---|---|---|---|---|
| 7.1 | `rm ~/mission/ops/backup/routes.txt` | Backup copy of `routes.txt` deleted (simulated mistake) | `ls ~/mission/ops/backup/` (empty) | Terminal output before/after |
| 7.2 | `cp ~/mission/intel/routes.txt ~/mission/ops/backup/` | File restored to `backup/` from the still-intact `intel/` copy | `ls ~/mission/ops/backup/` shows `routes.txt` again | Terminal output |

---

## Phase 8 — Advanced Permissions & Ownership (run as: `root` then `agent007`)

**Goal:** Observe how ownership changes affect file access/visibility for the original
owner.

| Step | Command | Who runs it | Expected Result | Verify | Evidence |
|---|---|---|---|---|---|
| 8.1 | `sudo chown root ~/mission/intel/targets.txt` *(or, from a root shell:* `chown root /home/agent007/mission/intel/targets.txt`*)* | `root` | Owner of `targets.txt` changes from `agent007` to `root` | `ls -l ~/mission/intel/targets.txt` | Terminal output |
| 8.2 | `su - agent007` (switch back if you left the session) | — | Back in `agent007`'s shell | `whoami` | — |
| 8.3 | `ls -l ~/mission/intel/targets.txt` | `agent007` | Listing shows owner is now `root`; because permissions were set to `640` in Phase 6, `agent007` (now only in the "others" bucket for this file unless in `root`'s group) may lose write access | Compare to Phase 6 output | Screenshot showing the changed owner column |

> **Observation to record in your submission:** after the `chown`, `agent007` is no longer
> the file's owner. Since Phase 6 set `others` permissions to `---`, `agent007` — unless a
> member of the file's new group — effectively loses read/write access to `targets.txt`.
> This demonstrates why ownership and group permissions must be planned together.

---

## Phase 9 — Evidence Collection & Final Verification (run as: `agent007`)

| Step | Command | Expected Result | Evidence |
|---|---|---|---|
| 9.1 | `ls -laR ~/mission/` | Full recursive long-format listing of the entire mission tree | Save to `submission/final-output.txt` and/or screenshot to `evidence/screenshots/` |
| 9.2 | `history > ~/command-history.txt` (or copy `.bash_history`) | Full list of commands run during the lab | Save to `submission/command-history.txt` |

---

## Phase 10 — Final Submission (no commands)

Assemble into the `submission/` folder:

1. `command-history.txt` — from Phase 9.2
2. `final-output.txt` — from Phase 9.1
3. A 4–5 line written explanation of `chmod`, `ls -l`, and `useradd` (a draft is provided in
   [`docs/task-overview.md`](../docs/task-overview.md))
