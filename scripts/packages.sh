#!/usr/bin/env bash

set -e

echo "==> Updating system..."
sudo pacman -Syu --noconfirm

echo "==> Installing pacman packages..."
sudo pacman -S --needed --noconfirm $(grep -v '^#' packages/pacman.txt)

if ! command -v yay &> /dev/null; then
    echo "==> Installing yay (AUR helper)..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
fi

echo "==> Installing AUR packages..."
yay -S --needed --noconfirm $(grep -v '^#' packages/aur.txt)
