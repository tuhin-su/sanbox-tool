Below is a **clear, user-friendly guide** you can give to **anyone**.
No internals, no bwrap knowledge needed.

---

# 🧰 SANBOX — User Guide

**SANBOX** is a lightweight sandbox tool for Linux (Arch-based) that works like
**Python `venv`, but for the whole operating system**.

It gives you:

* Fake root access
* No host system changes
* Read-only system binaries
* Clean OPSEC for labs (HTB, TryHackMe, etc.)

---

## 🔧 Requirements

* Arch Linux (or Arch-based)
* `bubblewrap` installed

```bash
sudo pacman -S bubblewrap
```

---

## 🚀 Quick Start (Recommended Workflow)

### 1️⃣ Create a new sandbox

```bash
sanbox new htb
```

This creates a folder:

```
htb/
├── config
├── root/
├── home/
└── loot/
```

---

### 2️⃣ Enter the sandbox

```bash
cd htb
sanbox
```

That’s it.
You are now **inside the sandbox**.

Prompt will look like:

```text
[htb] / #
```

---

### 3️⃣ Exit the sandbox

```bash
exit
```

The sandbox is destroyed (except your files).

---

## 🧠 How SANBOX Works (Simple Explanation)

* Each sandbox is **just a folder**
* Entering the folder and running `sanbox` activates it
* Your **real system is never modified**
* System tools are mounted **read-only**
* Logs are disabled
* Temp files are isolated

Think of it like:

```text
python venv → sanbox
```

---

## 📁 Directory Structure (Inside Sandbox Folder)

| Path     | Purpose                            |
| -------- | ---------------------------------- |
| `root/`  | Fake root filesystem               |
| `home/`  | Your sandbox home directory        |
| `loot/`  | Writable folder for extracted data |
| `config` | Sandbox configuration              |

---

## 🗂 Temporary Files

Each sandbox gets its own temp folder:

```
/tmp/sanbox-<sandbox-name>-tmp
```

This folder is:

* Used as `/tmp` inside the sandbox
* Automatically created
* Safe to delete after exit

---

## 🔐 Default Security Model (Safe by Default)

| Feature             | Status    |
| ------------------- | --------- |
| Fake root           | ✅         |
| Real network access | ✅         |
| Open ports          | ✅         |
| System binaries     | Read-only |
| Host logs           | ❌         |
| Host `/etc`, `/var` | ❌         |

This is **ideal for labs and exploit testing**.

---

## ⚙️ Configuration (Optional)

Edit the `config` file inside the sandbox folder.

### Example `config`

```bash
SYSTEM=ro          # ro | isolated
WORDLISTS=yes
RW_PATHS=/loot
```

### Options explained

#### `SYSTEM`

* `ro` → Read-only system (recommended)
* `isolated` → No system binaries at all

#### `WORDLISTS`

* `yes` → Mount system wordlists read-only
* `no` → No wordlists

#### `RW_PATHS`

Comma-separated writable paths:

```bash
RW_PATHS=/loot,/opt/tools
```

Everything else remains read-only.

---

## 📦 Using Tools Inside SANBOX

All normal tools work:

```bash
nmap
ffuf
sqlmap
gcc
python
```

Wordlists:

```bash
/usr/share/wordlists
```

Temporary work:

```bash
/tmp
```

Loot:

```bash
/loot
```

---

## 🧹 Cleaning Up

Delete a sandbox:

```bash
rm -rf htb
```

Remove temp files (optional):

```bash
rm -rf /tmp/sanbox-htb-tmp
```

---

## ⚠️ Limitations (Important)

SANBOX **cannot**:

* Load kernel modules
* Change host firewall
* Modify host kernel
* Persist system changes

This is intentional for safety.

---

## 🧠 Best Practices

* One sandbox per target
* Store findings in `/loot`
* Delete sandbox after finishing a lab
* Never mount system paths as writable
* Keep `SYSTEM=ro` unless you know why

---

## ✅ When to Use SANBOX

✔ HTB / TryHackMe
✔ Exploit testing
✔ Malware analysis (basic)
✔ Untrusted scripts
✔ OPSEC-clean environments

---

## 🆘 Troubleshooting

### `sanbox: no sandbox here`

You are not inside a sandbox folder.
Run:

```bash
cd <sandbox-name>
sanbox
```

### Command not found

Ensure:

```bash
~/.local/bin is in PATH
```

---