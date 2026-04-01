#!/usr/bin/env bash

set -e

# -----------------------------------------------------------------------------
# doom.sh — Doom Emacs setup
# Installs dependencies, clones Doom, configures PATH, installs fonts, syncs.
# -----------------------------------------------------------------------------

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
RED="\033[0;31m"
BOLD="\033[1m"
RESET="\033[0m"

info()    { echo -e "${CYAN}${BOLD}==>${RESET} $*"; }
success() { echo -e "${GREEN}    ✔${RESET} $*"; }
warning() { echo -e "${YELLOW}    ⚠${RESET} $*"; }
error()   { echo -e "${RED}    ✖${RESET} $*"; }

DOOM_DIR="$HOME/.config/emacs"
DOOM_BIN="$DOOM_DIR/bin/doom"

# --- Dependencies -------------------------------------------------------------

DEPS=(
    emacs
    git
    cmake
    libtool
    libvterm
    ripgrep
    fd
    sqlite
    shellcheck
    shfmt
    ttf-nerd-fonts-symbols-common
)

info "Installing Doom Emacs dependencies..."
sudo pacman -S --needed --noconfirm "${DEPS[@]}"
success "Dependencies installed."

# --- Clone Doom Emacs ---------------------------------------------------------

if [ -d "$DOOM_DIR" ]; then
    warning "Doom Emacs directory already exists at ${DOOM_DIR}."
    read -rp "    Reinstall? This will remove the existing directory. [y/N] " CONFIRM
    if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
        info "Removing existing Doom installation..."
        rm -rf "$DOOM_DIR"
    else
        info "Skipping clone. Using existing installation."
    fi
fi

if [ ! -d "$DOOM_DIR" ]; then
    info "Cloning Doom Emacs to ${DOOM_DIR}..."
    git clone --depth 1 https://github.com/doomemacs/doomemacs "$DOOM_DIR"
    success "Doom Emacs cloned."
fi

# --- PATH setup ---------------------------------------------------------------

add_to_path() {
    local rc_file="$1"
    local export_line='export PATH="$HOME/.config/emacs/bin:$PATH"'

    if [ -f "$rc_file" ]; then
        if ! grep -qF '.config/emacs/bin' "$rc_file"; then
            echo "" >> "$rc_file"
            echo "# Doom Emacs" >> "$rc_file"
            echo "$export_line" >> "$rc_file"
            success "PATH added to $(basename "$rc_file")"
        else
            success "PATH already present in $(basename "$rc_file"), skipping."
        fi
    fi
}

info "Configuring PATH for doom binary..."
add_to_path "$HOME/.zshrc"
add_to_path "$HOME/.bashrc"

# Export for the remainder of this session
export PATH="$HOME/.config/emacs/bin:$PATH"

# --- Run doom install ---------------------------------------------------------

if [ ! -x "$DOOM_BIN" ]; then
    error "doom binary not found at ${DOOM_BIN}. Clone may have failed."
    exit 1
fi

info "Running doom install (this will take a few minutes)..."
"$DOOM_BIN" install --no-fonts
success "Doom installed."

# --- Nerd Icons fonts ---------------------------------------------------------
# ttf-nerd-fonts-symbols-common covers the icons used by nerd-icons.el.
# If you prefer to install via Emacs itself:
#   M-x nerd-icons-install-fonts  (or SPC : nerd-icons-install-fonts in Doom)
# then confirm the default save path (~/.local/share/fonts).

info "Refreshing font cache..."
fc-cache -fv > /dev/null 2>&1
success "Font cache refreshed."

# --- doom sync ----------------------------------------------------------------

info "Running doom sync..."
"$DOOM_BIN" sync
success "Doom sync complete."

# --- Summary ------------------------------------------------------------------

echo ""
info "Doom Emacs setup complete."
echo ""
echo -e "  ${CYAN}Next steps:${RESET}"
echo -e "  1. ${GREEN}Restart your terminal${RESET} or run: export PATH=\"\$HOME/.config/emacs/bin:\$PATH\""
echo -e "  2. Launch Emacs with: ${GREEN}emacs${RESET} or ${GREEN}doom run${RESET}"
echo -e "  3. Run ${GREEN}doom doctor${RESET} to check for any missing dependencies."
echo -e "  4. To install nerd icons fonts from within Emacs:"
echo -e "     ${GREEN}SPC :${RESET}  then  ${GREEN}nerd-icons-install-fonts${RESET}  →  confirm with Enter"
echo -e "  5. Use ${GREEN}SPC q r${RESET} to reload Doom without restarting Emacs."
echo ""
