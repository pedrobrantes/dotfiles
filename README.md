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

### 2. Clone the Repository

Next, enter a temporary shell that contains `git` and clone the repository.

```bash
nix-shell -p git --run "git clone 'https://github.com/pedrobrantes/dotfiles.git' '${HOME}/.config/home-manager'"
cd ~/.config/home-manager
```

### 3. Configure Secrets with Bitwarden and SOPS

This configuration uses `sops-nix` to manage secrets, which are securely stored in Bitwarden.

First, get a shell with `bitwarden-cli` and log in:
```bash
nix-shell -p bitwarden-cli --run "
  bw login
  export BW_SESSION=\$(bw unlock --raw)
  mkdir -p ~/.config/sops/age
  bw get notes sops-nix_age_private.key | tee ~/.config/sops/age/keys.txt
  chmod 600 ~/.config/sops/age/keys.txt
  bw lock
"
```

### 4. Apply the Configuration

Finally, apply the configuration using Home Manager. This command needs the `flakes` experimental feature enabled for the first run.

```bash
nix-shell -p home-manager git

# For x86_64 architecture
home-manager switch --flake .#brantes-x86_64-linux --extra-experimental-features 'nix-command flakes'

# For aarch64 architecture (example)
# home-manager switch --flake .#brantes-aarch64-linux --extra-experimental-features 'nix-command flakes'
```

After the first successful run, your Nix configuration will permanently enable flakes and install Home Manager in your profile. You will no longer need the `--extra-experimental-features` flag for subsequent runs.

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
