#!/usr/bin/env bash
set -euo pipefail

# --- Configuration ---
readonly GIT_REPO_URL="https://github.com/pedrobrantes/dotfiles.git"
readonly BW_NOTE_NAME="sops-nix_age_private.key"
# --- End of Configuration ---

# --- Script Variables ---
readonly CONFIG_DIR="${HOME}/.config/home-manager"
readonly SOPS_AGE_KEY_FILE="${HOME}/.config/sops/age/keys.txt"
readonly NIX_FLAGS='--extra-experimental-features "nix-command flakes"'

# --- Helper Functions for Logging ---
readonly COLOR_BLUE='\033[0;34m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_YELLOW='\033[0;33m'
readonly COLOR_RED='\033[0;31m'
readonly COLOR_RESET='\033[0m'

info() {
  echo -e "${COLOR_BLUE}[INFO]${COLOR_RESET} $1"
}
success() {
  echo -e "${COLOR_GREEN}[SUCCESS]${COLOR_RESET} $1"
}
warn() {
  echo -e "${COLOR_YELLOW}[WARNING]${COLOR_RESET} $1"
}
error() {
  echo -e "${COLOR_RED}[ERROR]${COLOR_RESET} $1" >&2
  exit 1
}

# --- Prerequisite Functions ---
check_and_install_nix() {
  if command -v nix-shell &> /dev/null; then
    success "Nix is already installed."
    return
  fi

  warn "Nix command not found."
  read -p "Would you like to install it now using the official installer? [y/N] " choice
  case "$choice" in
    y|Y )
      info "Running the official Nix installer..."
      sh <(curl -L https://nixos.org/nix/install) --daemon
      warn "Nix has been installed. Please restart your shell or run 'source /etc/profile.d/nix.sh' and then run this script again."
      exit 0
      ;;
    * )
      error "Nix is required to continue. Aborting."
      ;;
  esac
}

clone_config_repo() {
  if [ -d "$CONFIG_DIR" ]; then
    info "Configuration directory already exists at ${CONFIG_DIR}. Skipping clone."
    return
  fi

  info "Cloning configuration repository from ${GIT_REPO_URL}..."
  if command -v git &> /dev/null; then
    git clone "$GIT_REPO_URL" "$CONFIG_DIR"
  else
    warn "Git not found. Using nix-shell to provide a temporary Git environment."
    nix-shell $NIX_FLAGS -p git --run "git clone '$GIT_REPO_URL' '$CONFIG_DIR'"
  fi
}


# --- Main Logic ---
main() {
  info "Starting bootstrap process for Nix Home Manager..."

  check_and_install_nix
  clone_config_repo
  cd "$CONFIG_DIR"

  if [ -f "$SOPS_AGE_KEY_FILE" ]; then
    success "Sops key file already exists at ${SOPS_AGE_KEY_FILE}. Skipping Bitwarden."
  else
    info "Sops key file not found. Starting Bitwarden workflow."
    warn "You will be prompted for your Bitwarden credentials."

    nix-shell $NIX_FLAGS -p bitwarden-cli --run "
      set -euo pipefail
      if ! bw status | grep -q '\"status\":\"unlocked\"'; then
        if ! bw status | grep -q '\"status\":\"locked\"'; then
          echo '[INFO] Logging in to Bitwarden...'
          bw login
        fi
      fi
      echo '[INFO] Unlocking Bitwarden vault...'
      export BW_SESSION=\$(bw unlock --raw)
      if [ -z \"\$BW_SESSION\" ]; then
        echo '[ERROR] Failed to unlock Bitwarden vault.' >&2
        exit 1
      fi
      echo '[SUCCESS] Vault unlocked.'
      mkdir -p \"$(dirname "$SOPS_AGE_KEY_FILE")\"
      echo '[INFO] Fetching sops key from Bitwarden note: ${BW_NOTE_NAME}'
      bw get notes \"$BW_NOTE_NAME\" > \"$SOPS_AGE_KEY_FILE\"
      chmod 600 \"$SOPS_AGE_KEY_FILE\"
      bw lock
      echo '[INFO] Bitwarden vault locked.'
    "
    success "Sops key file created successfully at ${SOPS_AGE_KEY_FILE}"
  fi

  info "Applying Home Manager configuration..."
  home-manager switch $NIX_FLAGS --flake ".#brantes"

  success "Bootstrap complete! Your declarative environment is ready."
  info "You can now permanently enable flakes by adding 'experimental-features = nix-command flakes' to your nix.conf file."
}

main
