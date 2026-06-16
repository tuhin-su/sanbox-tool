# 🧰 SANBOX — Lightweight OS-Level Sandboxing

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![OS: Linux](https://img.shields.io/badge/OS-Linux-blue.svg)](https://www.linux.org/)
[![Dependency: Bubblewrap](https://img.shields.io/badge/Dependency-Bubblewrap-orange.svg)](https://github.com/containers/bubblewrap)

**SANBOX** is an ultra-lightweight, daemonless OS-level sandbox tool for Linux. Working similarly to Python's `venv` but for your entire operating system, it allows you to run applications, test exploits, and execute suspicious files in an isolated environment without modifying or endangering your host system.

---

## 🔍 What is SANBOX?

SANBOX is a command-line wrapper built on top of [Bubblewrap (`bwrap`)](https://github.com/containers/bubblewrap), a low-level sandboxing tool that utilizes Linux namespaces (`mount`, `user`, `pid`, `ipc`, `net`, `uts`). 

Unlike heavy virtual machines (VMs) or container systems (like Docker) which require persistent daemons, image registries, and significant CPU/memory overhead, SANBOX:
* **Starts Instantly**: Boots an isolated environment in milliseconds.
* **Is Daemonless**: Requires no background services running on your machine.
* **Runs as Non-Root**: Safely creates fake root environments without actual root privileges.
* **Uses Your Host System Files**: Can mount system binaries `/usr` and libraries read-only, avoiding the need to download large operating system images.

---

## 🎯 What Problems Does It Solve?

SANBOX is designed to provide secure, ephemeral workspaces for developers, security researchers, and system administrators. It solves several critical security and workflow problems:

### 1. Reverse Engineering & Binary Debugging
When analyzing untrusted binaries, compilers, or debuggers, running them natively risks host contamination. SANBOX provides:
* **Read-Only System Paths**: Key directories like `/usr`, `/bin`, and `/lib` are mounted read-only (`ro`), meaning binaries cannot patch or overwrite system files.
* **Isolated Environment**: System configurations (`/etc`, `/var`, `/run`) are mounted as empty temporary filesystems (`tmpfs`), preventing binaries from accessing or corrupting configuration databases.

### 2. Malware Protection & Analysis
Executing potentially malicious scripts or programs (e.g., untrusted Python packages, malware samples, or obfuscated payloads) poses severe system security threats. SANBOX mitigates this by:
* **Faked Privileges**: Even inside the sandbox where you appear as `root` (`uid 0`), you have no real root privileges on the host system.
* **Host Protection**: File writes are isolated to the sandbox folder structure (`root/` or `home/`). When you exit the sandbox, the temporary namespace mounts are destroyed, isolating any system modifications.

### 3. Exploit & Lab Testing (OPSEC)
When participating in CTFs (like Hack The Box, TryHackMe) or performing penetration tests, it is critical to maintain clean Operations Security (OPSEC):
* **No Host Leaks**: Host environment variables, bash history, ssh keys, and system logs are cleared (`--clearenv`), ensuring you don't accidentally leak host details.
* **Network Isolation Options**: Network access can be monitored or disabled entirely if needed, keeping your lab environment contained.

### 4. Temporary/Dirty Environments
If you need to run installer scripts, compile experimental packages, or run tools that generate messy temporary directories:
* **Isolated `/tmp`**: Every sandbox has its own isolated, unique temp folder.
* **Zero Host Clutter**: Delete the sandbox directory, and all associated artifacts are permanently gone.

---

## 🔧 Setup & Installation

Since SANBOX leverages Linux kernel namespaces via `bubblewrap`, it runs natively on Linux. However, it can easily be configured on macOS and Windows using virtualization technologies.

### 🐧 1. Linux Setup (Native)

First, install the `bubblewrap` package using your distribution's package manager:

```bash
# Arch Linux / Manjaro
sudo pacman -S bubblewrap

# Debian / Ubuntu / Mint / Kali
sudo apt update && sudo apt install -y bubblewrap

# Fedora / Red Hat / CentOS
sudo dnf install -y bubblewrap

# Alpine Linux
sudo apk add bubblewrap
```

Next, install SANBOX:

```bash
# Clone the repository (if not already done)
git clone https://github.com/yourusername/sanbox-tool.git
cd sanbox-tool

# Run the installer
# (Installs to ~/.local/bin/sanbox if run as a regular user, or /usr/local/bin/sanbox if run as root)
./install.sh
```

> [!IMPORTANT]
> If you installed as a regular user, make sure `~/.local/bin` is in your environment's `PATH`. You can add this to your `~/.bashrc` or `~/.zshrc`:
> ```bash
> export PATH="$HOME/.local/bin:$PATH"
> ```

---

### 🪟 2. Windows Setup (via WSL 2)

Windows does not natively support Linux namespaces. To run SANBOX, use **Windows Subsystem for Linux (WSL 2)**, which runs a native Linux kernel:

1. Open PowerShell as Administrator and enable WSL:
   ```powershell
   wsl --install
   ```
2. Restart your computer if prompted.
3. Open your installed Linux distribution terminal (e.g., Ubuntu).
4. Install `bubblewrap` and SANBOX inside WSL exactly as described in the **Linux Setup** instructions:
   ```bash
   sudo apt update && sudo apt install -y bubblewrap git
   git clone https://github.com/yourusername/sanbox-tool.git
   cd sanbox-tool && ./install.sh
   ```

---

### 🍏 3. macOS Setup (via Linux VM)

macOS does not support Linux namespaces or `bubblewrap` natively. The recommended way to run SANBOX on macOS is through a lightweight Linux virtualization environment.

#### Option A: Using Lima (Recommended)
[Lima](https://github.com/lima-vm/lima) launches Linux virtual machines on macOS with automatic file sharing and port forwarding.

1. Install Lima using Homebrew:
   ```bash
   brew install lima
   ```
2. Start the default Linux VM:
   ```bash
   limactl start
   ```
3. Enter the VM shell:
   ```bash
   lima
   ```
4. Install `bubblewrap` and SANBOX inside the VM:
   ```bash
   sudo apt update && sudo apt install -y bubblewrap git
   git clone https://github.com/yourusername/sanbox-tool.git
   cd sanbox-tool && ./install.sh
   ```

#### Option B: Using Multipass
[Multipass](https://multipass.run/) is a lightweight VM manager by Canonical.

1. Install Multipass:
   ```bash
   brew install --cask multipass
   ```
2. Launch an Ubuntu instance:
   ```bash
   multipass launch --name sanbox-host
   ```
3. Open a shell inside the instance:
   ```bash
   multipass shell sanbox-host
   ```
4. Install `bubblewrap` and follow the standard **Linux Setup**.

---

## 🚀 Quick Start Guide

### 1️⃣ Create a Sandbox
Create a new sandbox instance inside a folder.
```bash
sanbox new target-env
```
This initializes a directory named `target-env` with the following structure:
```text
target-env/
├── config        # Sandbox configuration options
├── root/         # Fake root filesystem for sandbox writes
├── home/         # Isolated home directory
└── loot/         # Writable directory for persistent exports
```

### 2️⃣ Run the Sandbox
Navigate into the sandbox directory and start it:
```bash
cd target-env
sanbox
```
You will enter a subshell where the prompt reflects the sandbox name:
```text
[target-env] / # 
```

### 3️⃣ Exit the Sandbox
To exit the sandbox and safely teardown the mounts:
```bash
exit
```

---

## ⚙️ Configuration File (`config`)

You can customize the sandbox behavior by editing the `config` file inside the sandbox directory:

```bash
# SYSTEM configuration:
# - ro       : Mounts host binaries (/usr, /bin, /lib, etc.) as read-only (Recommended)
# - isolated : Provides a completely empty system namespace with no host binaries
SYSTEM=ro

# Comma-separated list of paths inside the sandbox that should map to persistent,
# writable directories on your host (relative to the sandbox root).
RW_PATHS=/loot
```

---

## 🔐 Security & Constraints

| Feature | Status | Details |
| :--- | :---: | :--- |
| **Fake Root** | ✅ | You are `root` inside the sandbox but have no elevated host privileges. |
| **Network Access** | ✅ | Uses host network configuration. |
| **Host Configuration** | ❌ | Host `/etc` and `/var` are hidden; only blank temporary file systems are visible. |
| **Kernel Modifications** | ❌ | Cannot load kernel modules, modify sysctl parameters, or modify host firewalls. |
| **System Binaries** | Read-only | Prevents malware or tools from modifying existing executables in `/usr/bin`, etc. |

---

## 🧹 Cleanup & Uninstallation

To completely delete a sandbox and its isolated files:
```bash
rm -rf target-env/
```

To remove SANBOX from your system:
```bash
rm -f ~/.local/bin/sanbox
# Or if installed system-wide:
sudo rm -f /usr/local/bin/sanbox
```

---

## 📄 License
This project is licensed under the MIT License. See the LICENSE file for details.
