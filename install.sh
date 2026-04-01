#!/usr/bin/env bash

set -e

# =============================================================================
# misaki — personal bootstrap for EndeavourOS (i3wm)
# https://github.com/0x2fycy3/misaki
# =============================================================================

# ─── Colors ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

info()    { echo -e "${CYAN}${BOLD}==> $1${NC}"; }
success() { echo -e "${GREEN}    ✔ $1${NC}"; }
warn()    { echo -e "${YELLOW}    ⚠ $1${NC}"; }
die()     { echo -e "${RED}${BOLD}    ✖ $1${NC}"; exit 1; }

# ─── Banner ───────────────────────────────────────────────────────────────────
echo ""
echo -e "${CYAN}${BOLD}"
echo "  ███╗   ███╗██╗███████╗ █████╗ ██╗  ██╗██╗"
echo "  ████╗ ████║██║██╔════╝██╔══██╗██║ ██╔╝██║"
echo "  ██╔████╔██║██║███████╗███████║█████╔╝ ██║"
echo "  ██║╚██╔╝██║██║╚════██║██╔══██║██╔═██╗ ██║"
echo "  ██║ ╚═╝ ██║██║███████║██║  ██║██║  ██╗██║"
echo "  ╚═╝     ╚═╝╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝"
echo -e "${NC}"
echo -e "  ${BOLD}EndeavourOS · i3wm · Personal Bootstrap${NC}"
echo ""

# ─── OS Check ─────────────────────────────────────────────────────────────────
info "Checking system compatibility..."

if [ ! -f /etc/os-release ]; then
    die "Cannot detect OS. /etc/os-release not found."
fi

source /etc/os-release

if [[ "$ID" != "endeavouros" && "$ID_LIKE" != *"arch"* && "$ID" != "arch" ]]; then
    warn "This setup is designed for EndeavourOS / Arch Linux."
    warn "Detected: ${PRETTY_NAME:-unknown}"
    echo ""
    read -rp "    Continue anyway? [y/N] " CONFIRM
    [[ "$CONFIRM" =~ ^[Yy]$ ]] || die "Aborted."
else
    success "Running on: ${PRETTY_NAME}"
fi

# ─── Dependencies check ───────────────────────────────────────────────────────
for cmd in git bash sudo; do
    command -v "$cmd" &>/dev/null || die "'${cmd}' is required but not installed."
done

# ─── Clone / update repo ──────────────────────────────────────────────────────
REPO="https://github.com/0x2fycy3/misaki.git"
DIR="$HOME/.misaki"

if [ ! -d "$DIR" ]; then
    info "Cloning repository to ${DIR}..."
    git clone "$REPO" "$DIR"
    success "Repository cloned."
else
    info "Repository already exists at ${DIR}. Pulling latest changes..."
    git -C "$DIR" pull --ff-only && success "Up to date." || warn "Could not pull. Continuing with local copy."
fi

cd "$DIR"

# ─── Run scripts ──────────────────────────────────────────────────────────────
run_step() {
    local label="$1"
    local script="$2"

    echo ""
    info "[${label}] ${script}"
    echo "  ─────────────────────────────────────────"

    if [ -f "$script" ]; then
        bash "$script"
        success "${label} complete."
    else
        warn "Script not found: ${script} — skipping."
    fi
}

run_step "1/5  Packages"  "scripts/packages.sh"
run_step "2/5  Dotfiles"  "scripts/dotfiles.sh"
run_step "3/5  Services"  "scripts/services.sh"
run_step "4/5  IME"       "scripts/ime.sh"
run_step "5/5  Doom"      "scripts/doom.sh"

# ─── Done ─────────────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}  ✔  misaki setup complete. Enjoy your system.${NC}"
echo -e "     Log out and back in for all changes to take effect."
echo ""
