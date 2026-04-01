#!/usr/bin/env bash

set -e

# -----------------------------------------------------------------------------
# services.sh — enable system services, set defaults, configure autostart
# -----------------------------------------------------------------------------

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RESET="\033[0m"

info()    { echo -e "${GREEN}==>${RESET} $*"; }
warning() { echo -e "${YELLOW}[!]${RESET} $*"; }

# --- Systemd Services --------------------------------------------------------

info "Enabling NetworkManager..."
sudo systemctl enable --now NetworkManager

info "Enabling Bluetooth..."
sudo systemctl enable --now bluetooth 2>/dev/null || warning "Bluetooth service not found, skipping."

info "Enabling firewalld..."
sudo systemctl enable --now firewalld 2>/dev/null || warning "firewalld not found, skipping."

info "Enabling CUPS (printing)..."
sudo systemctl enable --now cups 2>/dev/null || warning "CUPS not found, skipping."

info "Enabling haveged (entropy daemon)..."
sudo systemctl enable --now haveged 2>/dev/null || warning "haveged not found, skipping."

info "Enabling power-profiles-daemon..."
sudo systemctl enable --now power-profiles-daemon 2>/dev/null || warning "power-profiles-daemon not found, skipping."

# --- Default Browser — Brave -------------------------------------------------

if command -v xdg-settings &>/dev/null; then
    if [ -f /usr/share/applications/brave-browser.desktop ]; then
        info "Setting Brave as default browser..."
        xdg-settings set default-web-browser brave-browser.desktop
        xdg-mime default brave-browser.desktop x-scheme-handler/http
        xdg-mime default brave-browser.desktop x-scheme-handler/https
        info "Brave is now the default browser."
    else
        warning "brave-browser.desktop not found. Is brave-bin installed? Skipping."
    fi
else
    warning "xdg-settings not found. Install xdg-utils and re-run."
fi

# --- Nextcloud Client Autostart (XDG) ----------------------------------------

AUTOSTART_DIR="$HOME/.config/autostart"
NEXTCLOUD_DESKTOP="$AUTOSTART_DIR/Nextcloud.desktop"

mkdir -p "$AUTOSTART_DIR"

if command -v nextcloud &>/dev/null; then
    info "Creating Nextcloud autostart entry..."
    cat > "$NEXTCLOUD_DESKTOP" <<'EOF'
[Desktop Entry]
Name=Nextcloud
GenericName=File Synchronizer
Exec=/usr/bin/nextcloud --background
Terminal=false
Icon=Nextcloud
Categories=Network
Type=Application
StartupNotify=false
X-GNOME-Autostart-enabled=true
X-GNOME-Autostart-Delay=10
EOF
    info "Nextcloud will start automatically on login."
else
    warning "nextcloud binary not found. Is nextcloud-client installed? Skipping autostart entry."
fi

# --- /etc/environment — default BROWSER variable -----------------------------

ENV_FILE="/etc/environment"

if ! grep -q "^BROWSER=" "$ENV_FILE" 2>/dev/null; then
    info "Setting BROWSER=brave in $ENV_FILE..."
    echo "BROWSER=brave" | sudo tee -a "$ENV_FILE" > /dev/null
else
    info "BROWSER already set in $ENV_FILE, skipping."
fi

# -----------------------------------------------------------------------------

echo ""
info "Services and defaults configured successfully."
