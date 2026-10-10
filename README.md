# Secure File Management & User Configuration on Kali Linux

A hands-on Linux systems administration lab covering user account creation, privilege
management, directory structuring, file operations, permissions, and ownership recovery —
performed entirely from a **non-root user account** (`agent007`).

---

## 📌 Project Description

This repository documents a practical Linux lab in which a new user (`agent007`) is created
with sudo privileges, and then used to build and manage a "mission" workspace under
`/home/agent007/mission/`. The lab exercises core Linux administration skills: user
management, directory/file creation, output redirection, copying and deleting files,
permission changes with `chmod`, and ownership changes with `chown`, including simulating
and recovering from an accidental file deletion.

## 🎯 Objective

Demonstrate a working understanding of fundamental Linux file system and user management
commands by setting up a secure workspace for a newly created user and organizing files with
proper permissions and structure.

## 📋 Lab Requirements (from the task brief)

- The root user **must not** be used to perform the file operations.
- A new user, `agent007`, must be created first (this step, plus `usermod`, are the only
  operations allowed as root/sudo).
- All remaining steps must be performed while logged in as `agent007`.

## 🛠️ Technologies / Tools Used

- Kali Linux (or any Debian-based Linux distribution)
- Bash shell
- Core GNU utilities: `useradd`, `usermod`, `passwd`, `su`/`sudo`, `mkdir`, `cd`, `touch`,
  `ls`, `cp`, `rm`, `chmod`, `chown`

## ✅ Prerequisites

- Access to a Kali Linux machine or VM with root/sudo access
- Basic familiarity with the Linux terminal
- A terminal emulator capable of taking screenshots (for evidence collection)

## ⚙️ Environment / Setup Information

| Item | Value |
|---|---|
| OS | Kali Linux |
| New user | `agent007` |
| Shell assigned | `/bin/bash` |
| Group | `sudo` |
| Workspace root | `/home/agent007/mission/` |

---

## 📁 Project Structure

```
agent007-secure-workspace-lab/
│
├── README.md                     # This file
├── .gitignore
│
├── docs/
│   └── task-overview.md          # Original task requirements, restated
│
├── workflow/
│   └── workflow.md               # Full step-by-step procedure, phase by phase
│
├── commands/
│   └── commands.sh               # Every command used, in order, as a reference script
│
├── scripts/
│   └── setup-mission-workspace.sh # Automates steps 3–7 of the lab (run as agent007)
│
├── evidence/
│   ├── screenshots/              # Screenshots captured during the lab (.gitkeep placeholder)
│   └── terminal-output/          # Redirected command output / listing files
│
└── submission/
    ├── command-history.txt       # Paste your `history` / .bash_history output here
    └── final-output.txt          # Paste the final `ls -laR` output here
```

---

## 🧭 Step-by-Step Workflow (Summary)

See [`workflow/workflow.md`](workflow/workflow.md) for the full detailed procedure. Summary:

1. **Create the user** `agent007` (as root/sudo) with a home directory, `/bin/bash` shell,
   and membership in the `sudo` group.
2. **Set a password** for `agent007` and **switch to that account**. All further steps run
   as `agent007`.
3. **Build the workspace** directory tree:
   ```
   /home/agent007/mission/
   ├── intel/
   └── ops/
       └── backup/
   ```
4. **Create files** `targets.txt`, `routes.txt`, `keys.txt` inside `intel/`, then capture
   `ls`, `ls -l`, and `ls -la` output into `listing1.txt`, `listing2.txt`, `listing3.txt`.
5. **Copy** `routes.txt` into `ops/backup/`, then **delete** `keys.txt` from `intel/`.
6. **Set permissions** on `targets.txt` to `rw-r-----` (owner: read/write, group: read,
   others: none) using `chmod`, and verify with `ls -l`.
7. **Simulate an error**: delete `ops/backup/routes.txt`, then **recover** it by copying it
   again from `intel/routes.txt`.
8. **Change ownership**: as root, change the owner of `intel/targets.txt` to another user
   (e.g. `root`), then switch back to `agent007` and observe the effect with `ls -l`.

---

## 💻 Commands Used

The complete, ordered list of commands is kept in [`commands/commands.sh`](commands/commands.sh)
so it can be read as documentation or run as a reference script section by section.

---

## 📷 Expected Results & Evidence Requirements

Per the task brief, you must submit:

1. **Command history** — a copy of `.bash_history` or a pasted list of every command run
   (save into `submission/command-history.txt`).
2. **Final directory listing** — a screenshot or text file of the output of:
   ```bash
   ls -laR /home/agent007/mission/
   ```
   (save into `submission/final-output.txt`, and/or a screenshot into
   `evidence/screenshots/`).
3. **A short explanation (4–5 lines)** of what `chmod`, `ls -l`, and `useradd` do — see
   [`docs/task-overview.md`](docs/task-overview.md) for a drafted explanation you can adapt.

---

## 🧯 Troubleshooting

| Issue | Likely Cause | Fix |
|---|---|---|
| `useradd: Permission denied` | Not running as root/sudo | Prefix with `sudo` |
| `su: Authentication failure` | Password not set yet | Run `sudo passwd agent007` first |
| `mkdir: cannot create directory: Permission denied` | Attempting to write outside `/home/agent007` or as wrong user | Confirm you are logged in as `agent007` and inside their home directory |
| `chown` fails as `agent007` | Only root can change file ownership to another user | Run the `chown` step with `sudo` or as `root`, as the task specifies |
| `ls -l` shows unexpected permissions after `chown` | This is expected — the task asks you to *observe* the ownership change | Note the observation in your submission, no fix needed |

---

## 🔐 Safety / Permission Notes

- Never perform routine file operations as `root`. The `sudo` group membership on `agent007`
  should be used sparingly and only where the task explicitly calls for elevated privileges
  (`useradd`, `usermod`, and the final `chown` step).
- Use a strong password when running `passwd agent007`, even in a lab/VM environment.
- Double-check paths before running `rm` — deletions in this lab are intentional and part of
  the exercise, but `rm` is not reversible outside of this controlled recovery step.

---

## 📄 License

This repository is for educational/lab purposes.
