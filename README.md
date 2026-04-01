<div align="center">

# misaki

<img src="https://upload.wikimedia.org/wikipedia/commons/4/4b/EndeavourOS_Logo.svg" height="72" alt="EndeavourOS" />

**Personal bootstrap for EndeavourOS + i3wm**  
Opinionated. Reproducible.

[![EndeavourOS](https://img.shields.io/badge/EndeavourOS-7B2FBE?style=flat-square&logo=linux&logoColor=white)](https://endeavouros.com)
[![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=flat-square&logo=arch-linux&logoColor=white)](https://archlinux.org)
[![i3wm](https://img.shields.io/badge/i3wm-config-4C7A4E?style=flat-square)](https://github.com/0x2fycy3/endeavouros-i3wm-setup)
[![AUR](https://img.shields.io/badge/AUR-packages-1793D1?style=flat-square)](https://aur.archlinux.org)
[![Status](https://img.shields.io/badge/status-personal-lightgrey?style=flat-square)]()

</div>

---

## Overview

**misaki** automates the full post-install setup of an [EndeavourOS](https://endeavouros.com) machine running **i3wm**.
A single command clones this repo and runs every setup script in order — packages, dotfiles, services, and IME configuration.

> Built on [Arch Linux](https://archlinux.org) via [EndeavourOS](https://endeavouros.com) — a rolling-release distro that stays close to vanilla Arch while providing a polished out-of-the-box experience.

---

## i3wm Configuration

The window manager configuration used in this setup is based on the
**[endeavouros-i3wm-setup](https://github.com/0x2fycy3/endeavouros-i3wm-setup)** project.

> Want only the i3 config without the full bootstrap? Head there directly.

---

## Quick Install

> **Read the scripts before running.** This will modify your system, install packages, and overwrite configurations.

```bash
curl -fsSL https://raw.githubusercontent.com/0x2fycy3/misaki/main/install.sh | bash
```

---

## What It Does

| Step | Script                | Description                                                              |
| ---- | --------------------- | ------------------------------------------------------------------------ |
| 1    | `scripts/packages.sh` | Updates the system, installs all pacman and AUR packages via `yay`       |
| 2    | `scripts/dotfiles.sh` | Deploys dotfiles to `$HOME`, sets `zsh` as the default shell             |
| 3    | `scripts/services.sh` | Enables systemd services, sets default browser, configures autostart     |
| 4    | `scripts/ime.sh`      | Configures fcitx5 for Chinese input and installs the full CJK font stack |

---

## Project Structure

```
misaki/
├── install.sh
├── dotfiles/
│   └── .zshrc
├── packages/
│   ├── pacman.txt          # Official repo packages, organized by category
│   └── aur.txt             # AUR packages
└── scripts/
    ├── packages.sh
    ├── dotfiles.sh
    ├── services.sh
    └── ime.sh
```

---

## Chinese IME — fcitx5 (中文输入法)

`scripts/ime.sh` sets up Chinese input using **fcitx5**:

- Installs `fcitx5`, `fcitx5-chinese-addons`, `fcitx5-configtool`, `fcitx5-gtk`, `fcitx5-qt`
- Installs a full CJK font stack (Noto CJK, WQY, Source Han, Arphic)
- Writes the required environment variables to `/etc/environment`:

```ini
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
```

Run `fcitx5-configtool` after setup to add and configure input methods.

---

## Credits

Built on [EndeavourOS](https://endeavouros.com) ([Arch Linux](https://archlinux.org)) — i3wm config based on [endeavouros-i3wm-setup](https://github.com/0x2fycy3/endeavouros-i3wm-setup).

---

## Disclaimer

Personal setup, not affiliated with or endorsed by EndeavourOS or Arch Linux.
Review each script before running.
