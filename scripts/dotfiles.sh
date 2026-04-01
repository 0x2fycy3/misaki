# #!/usr/bin/env bash

# set -e

# DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/dotfiles"

# # ─── Colors ───────────────────────────────────────────────────────────────────
# RED='\033[0;31m'
# GREEN='\033[0;32m'
# YELLOW='\033[1;33m'
# CYAN='\033[0;36m'
# NC='\033[0m'

# info()    { echo -e "${CYAN}==> $1${NC}"; }
# success() { echo -e "${GREEN}    ✔ $1${NC}"; }
# warn()    { echo -e "${YELLOW}    ⚠ $1${NC}"; }
# error()   { echo -e "${RED}    ✖ $1${NC}"; }

# # ─── Deploy dotfiles ──────────────────────────────────────────────────────────
# info "Deploying dotfiles from ${DOTFILES_DIR}..."

# if [ ! -d "$DOTFILES_DIR" ]; then
#     error "Dotfiles directory not found: ${DOTFILES_DIR}"
#     exit 1
# fi

# deploy_file() {
#     local src="$1"
#     local dest="$HOME/$(basename "$src")"

#     if [ -e "$dest" ] && [ ! -L "$dest" ]; then
#         warn "Backing up existing $(basename "$dest") → $(basename "$dest").bak"
#         mv "$dest" "${dest}.bak"
#     fi

#     cp "$src" "$dest"
#     success "$(basename "$src") → ${dest}"
# }

# for file in "$DOTFILES_DIR"/.*; do
#     [ "$(basename "$file")" = "."  ] && continue
#     [ "$(basename "$file")" = ".." ] && continue
#     [ -f "$file" ] && deploy_file "$file"
# done

# # ─── Set Zsh as default shell ─────────────────────────────────────────────────
# info "Setting zsh as the default shell..."

# if command -v zsh &>/dev/null; then
#     ZSH_PATH="$(command -v zsh)"

#     # Ensure zsh is in /etc/shells
#     if ! grep -qx "$ZSH_PATH" /etc/shells; then
#         echo "$ZSH_PATH" | sudo tee -a /etc/shells > /dev/null
#         success "Added ${ZSH_PATH} to /etc/shells"
#     fi

#     # Change shell if not already zsh
#     if [ "$SHELL" != "$ZSH_PATH" ]; then
#         chsh -s "$ZSH_PATH"
#         success "Default shell changed to zsh (takes effect on next login)"
#     else
#         success "zsh is already the default shell"
#     fi
# else
#     warn "zsh not found — skipping shell change"
# fi

# echo ""
# echo -e "${GREEN}Dotfiles deployed.${NC}"
