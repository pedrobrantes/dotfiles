#!/usr/bin/env bash
set -euo pipefail

# --- Configuration ---
readonly GIT_REPO_URL="https://github.com/pedrobrantes/dotfiles.git"
readonly BW_NOTE_NAME="sops-nix_age_private.key"
readonly USERNAME="brantes"
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

info() { echo -e "${COLOR_BLUE}[INFO]${COLOR_RESET} $1"; }
success() { echo -e "${COLOR_GREEN}[SUCCESS]${COLOR_RESET} $1"; }
warn() { echo -e "${COLOR_YELLOW}[WARNING]${COLOR_RESET} $1"; }
error() { echo -e "${COLOR_RED}[ERROR]${COLOR_RESET} $1" >&2; exit 1; }

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
      if [[ "$(uname -m)" == "aarch64" ]]; then
        info "Detected aarch64 architecture. Installing Nix in single-user mode (Android/Termux)."
        sh <(curl -L https://nixos.org/nix/install) --no-daemon
      else
        info "Detected x86_64 architecture. Installing Nix in multi-user mode."
        sh <(curl -L https://nixos.org/nix/install) --daemon
      fi
      
      warn "Nix installed. Setting up environment variables for this session..."
      if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
        . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
      elif [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
        . "$HOME/.nix-profile/etc/profile.d/nix.sh"
      fi
      ;;
    * )
      error "Nix is required to continue. Aborting."
      ;;
  esac
}

clone_config_repo() {
  if [ -d "$CONFIG_DIR" ]; then
    info "Configuration directory already exists at ${CONFIG_DIR}. Pulling latest changes..."
    cd "$CONFIG_DIR" && git pull
    return
  fi

  info "Cloning configuration repository from ${GIT_REPO_URL}..."
  if command -v git &> /dev/null; then
    git clone "$GIT_REPO_URL" "$CONFIG_DIR"
  else
    warn "Git not found. Using nix-shell to provide a temporary Git environment."
    nix-shell -p git --run "git clone '$GIT_REPO_URL' '$CONFIG_DIR'"
  fi
}

detect_target() {
    local arch=$(uname -m)
    local os="linux"
    local device="desktop"
    local system_target=""

    if [[ -n "${TERMUX_VERSION:-}" ]]; then
        os="android"
        device="smartphone"
    elif grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null; then
        os="wsl"
        device="desktop"
    fi

    system_target="${USERNAME}@${arch}.${os}.${device}"

    echo "$system_target"
}

# --- Main Logic ---
main() {
  info "Starting bootstrap process for Nix Home Manager..."

  check_and_install_nix
  clone_config_repo
  
  cd "$CONFIG_DIR"

  # --- Bitwarden / SOPS Logic ---
  if [ -f "$SOPS_AGE_KEY_FILE" ]; then
    success "Sops key file already exists. Skipping Bitwarden."
  else
    info "Sops key file not found. Starting Bitwarden workflow."
    warn "You will be prompted for your Bitwarden credentials."
    
    # Using 'nix shell' to fetch bitwarden-cli temporarily
    nix-shell -p bitwarden-cli --run "
      set -euo pipefail
      if ! bw status | grep -q '\"status\":\"unlocked\"'; then
          echo '[INFO] Logging in to Bitwarden...'
          bw login
      fi
      
      echo '[INFO] Unlocking Bitwarden vault...'
      export BW_SESSION=\$(bw unlock --raw)
      
      mkdir -p \"$(dirname "$SOPS_AGE_KEY_FILE")\"
      echo '[INFO] Fetching sops key from Bitwarden note: ${BW_NOTE_NAME}'
      bw get notes \"$BW_NOTE_NAME\" > \"$SOPS_AGE_KEY_FILE\"
      chmod 600 \"$SOPS_AGE_KEY_FILE\"
      
      bw lock
      echo '[INFO] Bitwarden vault locked.'
    "
    success "Sops key file created successfully."
  fi

  # --- Flake Selection ---
  local flake_target
  flake_target=$(detect_target)
  
  info "Detected Environment Target: ${flake_target}"
  read -p "Is this target correct? [Y/n] " confirm
  if [[ "$confirm" =~ ^[Nn]$ ]]; then
      read -p "Please enter the full flake output name (e.g., brantes@x86_64.wsl.desktop): " manual_target
      flake_target="$manual_target"
  fi

  info "Applying Home Manager configuration..."

  # --- The Activation ---
  mkdir -p ~/.config/nix
  if ! grep -q "experimental-features" ~/.config/nix/nix.conf 2>/dev/null; then
      echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
  fi

  if [[ "$os" == "android" ]]; then
    info "Running Android-specific environment fixes..."
    [ -d "/homeless-shelter" ] && sudo rm -rf /homeless-shelter && rm -rf /homeless-shelter/
    export HOME="/home/${USERNAME}"
  fi

  nix run --extra-experimental-features "nix-command flakes" \
      home-manager -- switch --flake ".#${flake_target}"

  success "Bootstrap complete! Your declarative setup is ready."
  warn "Please restart your shell to apply all changes."
}

main
