# My Dotfiles

This repository contains my personal Nix configurations. It's managed by Nix and is designed to be reproducible across different machines.

The configuration is built with a **modular monolithic** approach. While the entire configuration is managed as a single unit (monolith), it is internally organized into logical, independent modules (e.g., for git, zsh, neovim). This structure makes it easy to manage, update, and understand individual components without affecting the whole system.

For details on how to add new configurations and run tests, please see the [**Development Guide (DEVELOPMENT.md)**](./DEVELOPMENT.md).

## Setup on a New Machine

Setting up a new machine from scratch involves these steps:

### 1. Install Nix

First, install the Nix package manager. The recommended multi-user installation is preferred. Open a terminal and run:

```bash
sh <(curl -L [https://nixos.org/nix/install](https://nixos.org/nix/install)) --daemon
```
Follow the on-screen instructions. After the installation, close and reopen your terminal to ensure the Nix environment is loaded.

### 2. Use temp git with nix-shell

```bash
nix-shell -p git --run "git clone 'https://github.com/pedrobrantes/dotfiles.git' '${HOME}/.config/home-manager'"
```

### 3. Config Bitwarden and keys

```bash
nix-shell -p bitwarden-cli
```

```bash
bw login
export BW_SESSION=$(bw unlock --raw)
mkdir -p ~/.config/sops/age
bw get notes sops-nix_age_private.key | tee ~/.config/sops/age/keys.txt
sudo chmod 600 ~/.config/sops/age/keys.txt
```

### 4. Install Home Manager

With Nix installed, install Home Manager using the specific **25.05** release channel.

```bash
nix-channel --add [https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz](https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz) home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
```
This will create the initial Home Manager files and directories.

### 5. Clone This Repository

Clone this repository into the Home Manager configuration directory (`~/.config/home-manager`).

```bash
git clone git@github.com:pedrobrantes/dotfiles.git ~/.config/home-manager
```

### 6. Apply the Configuration

Navigate to the directory and run `home-manager switch`. This command builds your configuration and activates it, creating all the necessary symlinks.

```bash
cd ~/.config/home-manager
home-manager switch --flake .#brantes
```

### OR use the boot script

```sh 
curl -sSL https://raw.githubusercontent.com/pedrobrantes/dotfiles/main/bootstrap.sh | sh
``

Your environment is now fully configured!
