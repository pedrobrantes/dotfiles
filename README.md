# My Dotfiles

This repository contains my personal Nix configurations. It's managed by Nix and is designed to be reproducible across different machines.

The configuration is built with a **modular monolithic** approach. While the entire configuration is managed as a single unit (monolith), it is internally organized into logical, independent modules (e.g., for git, zsh, neovim) and machine-specific hierarchies. This structure makes it easy to manage unique constraints for different devices (like Android/Termux vs. WSL/Desktop) while sharing common tools.

For details on how to add new configurations and run tests, please see the [**Development Guide (DEVELOPMENT.md)**](./DEVELOPMENT.md).

## Setup on a New Machine

The recommended way to set up a new machine is to use the `bootstrap.sh` script. It automates the entire process: installing Nix, cloning the repository, retrieving secrets from Bitwarden, running integration tests, and applying the correct configuration for the detected device.

Just run the following command in your terminal:

```sh
curl -sSL https://raw.githubusercontent.com/pedrobrantes/dotfiles/main/bootstrap.sh | sh
```

## Manual Installation

For those who prefer a step-by-step process or need to debug the installation, follow the instructions below.

<details>
<summary>Click to expand for manual installation steps</summary>
### 1. Install Nix

First, install the Nix package manager. The multi-user installation is recommended for standard Linux/WSL.

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

After the installation, close and reopen your terminal to ensure the Nix environment is loaded.

### 2. Clone the Repository

Next, enter a temporary shell that contains git and clone the repository.

```bash
nix-shell -p git --run "git clone 'https://github.com/pedrobrantes/dotfiles.git' '${HOME}/.config/home-manager'"
cd ~/.config/home-manager
```

### 3. Configure Secrets with Bitwarden and SOPS

This configuration uses `sops-nix` to manage secrets, which are securely stored in Bitwarden.
First, get a shell with bitwarden-cli and log in to retrieve your Age private key:

```bash
nix-shell -p bitwarden-cli --run "
  bw login
  export BW_SESSION=\$(bw unlock --raw)
  mkdir -p ~/.config/sops/age
  bw get notes sops-nix_age_private.key > ~/.config/sops/age/keys.txt
  chmod 600 ~/.config/sops/age/keys.txt
  bw lock
"
```

### 4. Apply the Configuration

Finally, apply the configuration using Home Manager. The flake outputs now follow the pattern username@arch.os.device.
For `x86_64` architecture (WSL/Desktop):

```bash
nix run home-manager -- switch --flake .#brantes@x86_64.wsl.desktop --extra-experimental-features 'nix-command flakes'
```

For `aarch64` architecture (Android/Smartphone):

```bash
nix run home-manager -- switch --flake .#brantes@aarch64.android.smartphone --extra-experimental-features 'nix-command flakes'
```

After the first successful run, your Nix configuration will permanently enable flakes and install Home Manager in your profile.
</details>

## Android Installation (via Termux)
<details>
<summary>Click to expand for Android installation steps</summary>
These instructions explain how to set up the environment on an Android device using Termux and a proot-distro (usually Ubuntu).

### 1. Set up Ubuntu Environment

First, inside Termux, install `proot-distro` and use it to install and log into an Ubuntu environment.

```bash
pkg install proot-distro
proot-distro install ubuntu
proot-distro login ubuntu
```

### 2. Create User and Set up Nix Directory

Inside the Ubuntu environment, create your user and the Nix directory.

```bash
adduser brantes
su brantes
mkdir /nix
```

### 3. Install Nix (Single-User)

On Android/PRoot, you must install Nix in single-user mode.

```bash
sh <(curl -L https://nixos.org/nix/install) --no-daemon
```

### 4. Apply Configuration

Follow the Manual Installation steps 2 and 3 (Clone and Secrets). Then, apply the configuration:

```bash
nix run home-manager -- switch --flake .#brantes@aarch64.android.smartphone --extra-experimental-features 'nix-command flakes' -b backup
```

It is highly recommended to use the -b backup flag on the first run to prevent conflicts with existing shell configuration files.
</details>
