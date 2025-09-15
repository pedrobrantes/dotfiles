# My Dotfiles

This repository contains my personal Nix configurations. It's managed by Nix and is designed to be reproducible across different machines.

The configuration is built with a **modular monolithic** approach. While the entire configuration is managed as a single unit (monolith), it is internally organized into logical, independent modules (e.g., for git, zsh, neovim). This structure makes it easy to manage, update, and understand individual components without affecting the whole system.

For details on how to add new configurations and run tests, please see the [**Development Guide (DEVELOPMENT.md)**](./DEVELOPMENT.md).

## Setup on a New Machine

The recommended way to set up a new machine is to use the `bootstrap.sh` script. It automates the entire process: installing Nix, cloning the repository, and applying the configuration.

Just run the following command in your terminal:

```sh 
curl -sSL https://raw.githubusercontent.com/pedrobrantes/dotfiles/main/bootstrap.sh | sh
```

## Manual Installation

For those who prefer a step-by-step process, follow the instructions below.

<details>
<summary>Click to expand for manual installation steps</summary>

### 1. Install Nix

First, install the Nix package manager. The multi-user installation is recommended.

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```
After the installation, **close and reopen your terminal** to ensure the Nix environment is loaded.

### 2. Install Home Manager

Next, install Home Manager, which is used to manage the user-specific environment.

```bash
nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
```

### 3. Clone This Repository

Next, clone this repository into the correct directory (`~/.config/home-manager`).

```bash
# This command uses a temporary git from nix-shell to clone the repo
nix-shell -p git --run "git clone 'https://github.com/pedrobrantes/dotfiles.git' '${HOME}/.config/home-manager'"
```

### 4. Configure Secrets with Bitwarden and SOPS

This configuration uses `sops-nix` to manage secrets, which are securely stored in Bitwarden.

First, ensure you have `bitwarden-cli` available:
```bash
nix-shell -p bitwarden-cli
```

Then, log in to Bitwarden and retrieve the SOPS private key:
```bash
# Log in to your Bitwarden account
bw login

# Unlock your vault and export the session key
export BW_SESSION=$(bw unlock --raw)

# Create the necessary directory for the age key
mkdir -p ~/.config/sops/age

# Retrieve the key from Bitwarden and save it
bw get notes sops-nix_age_private.key | tee ~/.config/sops/age/keys.txt

# Set the correct permissions for the key file
chmod 600 ~/.config/sops/age/keys.txt
```

### 5. Apply the Configuration

Finally, navigate to the repository directory and apply the configuration using Home Manager.

```bash
cd ~/.config/home-manager
home-manager switch --flake .#brantes-x86_64-linux # Or use -aarch64-linux
```

Your environment is now fully configured!

</details>

### Android Installation (via Termux)

<details>
<summary>Click to expand for Android installation steps</summary>

These instructions explain how to set up the environment on an Android device using Termux and a proot-distro of Ubuntu.

#### 1. Set up Ubuntu Environment

First, install `proot-distro` and use it to install and log into an Ubuntu environment.

```bash
pkg install proot-distro
proot-distro install ubuntu
proot-distro login ubuntu
```

#### 2. Create User and Set up Nix Directory

Inside the Ubuntu environment, create your user and a directory for Nix.

```bash
adduser "brantes"
su brantes
mkdir /nix
```

#### 3. Install Nix (Single-User)

Now, install Nix in single-user mode (`--no-daemon`).

```bash
sh <(curl -L https://nixos.org/nix/install) --no-daemon
```

After this, you can proceed with the standard manual installation steps (cloning the repository, setting up secrets, and applying the configuration) from within the `proot-distro` environment.

</details>