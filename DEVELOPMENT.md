# Development Guide

This document outlines the development workflow for managing and extending these dotfiles. The goal is to maintain a clean, stable, and testable configuration by using a `develop` branch for integration and keeping `main` as a stable release branch.

## Architectural Approach: Declarative Modular Monolith

This project is built on the **declarative nature** of Nix and organized as a **modular monolith**.

- **Declarative**: The core principle of Nix. We do not write scripts that command the system to *do* things (e.g., `apt install htop`). Instead, we write `.nix` files that **declare the desired final state** of the system (e.g., `packages = [ htop ];`). Nix's job is to figure out the steps to make the system match this declaration, ensuring reproducible and reliable environments.

- **Monolith**: The entire user environment is defined as a single, cohesive configuration that is deployed atomically with a single `home-manager switch` command. This ensures the whole system is always in a consistent state.

- **Modular**: Internally, this monolith is broken down into independent modules (e.g., `git.nix`, `zsh.nix`). Each module declaratively defines a specific tool or piece of functionality. This structure makes it easy to manage, update, and understand individual components without affecting the whole.

## Branching and Release Workflow

We use two primary branches to manage changes:
- `develop`: The main development branch. All new features are integrated here. It should always be functional, but it's where active development happens.
- `main`: The stable release branch. This branch only receives updates from `develop` when a set of features is complete and considered stable.

### Feature Development (Day-to-Day Cycle)

All new work, from adding a small tool to a big refactor, follows this cycle.

#### 1. Create a New Branch from `develop`

Before starting any work, create your feature branch from the latest version of the **`develop`** branch.

```bash
# Get the latest version of the develop branch
git checkout develop
git pull origin develop

# Create your new feature branch
git checkout -b feature/add-btop-config
```

#### 2. Add New Configurations and Tests

Make your changes to the `.nix` files, preferably by creating a new, self-contained module.

**Crucially, for any new functionality, add a corresponding test** in the `nix_tests` directory. This ensures our CI pipeline can validate your changes automatically. (See the [TEST TEMPLATES](./nix_tests/TEST_TEMPLATES.md) for examples).

#### 3. Commit and Push

Commit your changes to your feature branch and push it to the remote repository. Use a descriptive commit message following the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) standard.

```bash
git add .
git commit -m "feat: Add configuration for btop"
git push -u origin feature/add-btop-config
```

#### 4. Open a Pull Request to `develop`

Go to your repository on GitHub and open a Pull Request (PR) from your feature branch to the **`develop`** branch.

The CI pipeline will run on the PR. After it passes and you are satisfied with the changes, you can merge it into `develop`.

### Releasing to `main` (Promoting to Stable)

Periodically, when the `develop` branch contains a stable and complete set of features, you can create a new "release" on the `main` branch.

1.  **Merge `develop` into `main`**:
    ```bash
    # Go to the main branch and make sure it's up to date
    git checkout main
    git pull origin main

    # Merge all the changes from develop into main
    git merge develop --no-ff -m "chore(release): Merge develop into main"

    # Push the updated main branch
    git push origin main
    ```
    *(`--no-ff` creates a merge commit, which is good for visualizing the history of releases).*

2.  **(Optional) Create a Version Tag**:
    After merging to `main`, it is good practice to create a tag to mark the new version.
    ```bash
    git tag -a v1.1.0 -m "Release v1.1.0"
    git push origin v1.1.0
    ```
