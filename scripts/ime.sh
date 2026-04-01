#!/usr/bin/env bash

set -e

# -----------------------------------------------------------------------------
# ime.sh — Chinese IME setup using fcitx5
# Installs input method packages, CJK fonts, and configures /etc/environment
# -----------------------------------------------------------------------------

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
RED="\033[0;31m"
RESET="\033[0m"

info()    { echo -e "${CYAN}==>${RESET} $*"; }
success() { echo -e "${GREEN}    ✔${RESET} $*"; }
warning() { echo -e "${YELLOW}    ⚠${RESET} $*"; }
error()   { echo -e "${RED}    ✖${RESET} $*"; }

# --- fcitx5 packages ---------------------------------------------------------

FCITX5_PACKAGES=(
    fcitx5
    fcitx5-chinese-addons
    fcitx5-configtool
    fcitx5-gtk
    fcitx5-qt
)

info "Installing fcitx5 packages..."
sudo pacman -S --needed --noconfirm "${FCITX5_PACKAGES[@]}"
success "fcitx5 packages installed."

# --- CJK font stack ----------------------------------------------------------

CJK_FONTS=(
    noto-fonts-cjk
    adobe-source-han-sans-cn-fonts
    adobe-source-han-serif-cn-fonts
    wqy-microhei
    wqy-microhei-lite
    wqy-bitmapfont
    wqy-zenhei
    ttf-arphic-ukai
    ttf-arphic-uming
)

info "Installing CJK font stack..."
sudo pacman -S --needed --noconfirm "${CJK_FONTS[@]}"
success "CJK fonts installed."

# --- /etc/environment — IME environment variables ----------------------------

ENV_FILE="/etc/environment"

info "Configuring input method environment variables in ${ENV_FILE}..."

declare -A IME_VARS=(
    [GTK_IM_MODULE]=fcitx
    [QT_IM_MODULE]=fcitx
    [XMODIFIERS]="@im=fcitx"
)

for key in GTK_IM_MODULE QT_IM_MODULE XMODIFIERS; do
    value="${IME_VARS[$key]}"

    if grep -qE "^${key}=" "$ENV_FILE" 2>/dev/null; then
        sudo sed -i "s|^${key}=.*|${key}=${value}|" "$ENV_FILE"
        success "Updated  ${key}=${value}"
    else
        echo "${key}=${value}" | sudo tee -a "$ENV_FILE" > /dev/null
        success "Added    ${key}=${value}"
    fi
done

# --- fcitx5 autostart (XDG) --------------------------------------------------

AUTOSTART_DIR="$HOME/.config/autostart"
FCITX5_DESKTOP="$AUTOSTART_DIR/fcitx5.desktop"

mkdir -p "$AUTOSTART_DIR"

info "Creating fcitx5 XDG autostart entry..."
cat > "$FCITX5_DESKTOP" <<'EOF'
[Desktop Entry]
Name=Fcitx 5
GenericName=Input Method
Comment=Start Input Method
Exec=fcitx5 -d --replace
Icon=fcitx
Terminal=false
Type=Application
Categories=System;Utility;
X-GNOME-Autostart-Phase=Applications
X-GNOME-AutoRestart=false
X-GNOME-Autostart-Notify=false
X-KDE-autostart-after=panel
X-KDE-StartupNotify=false
EOF

success "fcitx5 autostart entry created at ${FCITX5_DESKTOP}"

# --- Refresh font cache -------------------------------------------------------

info "Refreshing font cache..."
fc-cache -fv > /dev/null 2>&1
success "Font cache refreshed."

# -----------------------------------------------------------------------------

echo ""
info "IME setup complete."
echo ""
echo -e "  ${CYAN}Next steps:${RESET}"
echo -e "  1. ${GREEN}Log out and log back in${RESET} for environment variables to take effect."
echo -e "  2. Run ${GREEN}fcitx5-configtool${RESET} to add Pinyin or other input methods."
echo -e "  3. Use ${GREEN}Ctrl+Space${RESET} (default) to toggle between input methods."
echo ""
