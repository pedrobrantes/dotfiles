# Nix Home Manager and Flakes Inputs Version/State Architecture

## 1. Overview

In the Nix ecosystem, system versioning is decoupled into two distinct layers: **Dependency Resolution** (defined in `flake.nix`) and **Configuration Behavior** (defined in `home.nix`). Understanding this separation is critical for maintaining a stable, reproducible environment while accessing the latest software updates.

## 2. The Supply Chain: `flake.nix` (Inputs)

The `inputs` section in `flake.nix` defines the **source of truth** for the software repositories.

```nix
inputs.home-manager.url = "github:nix-community/home-manager/release-25.11";
```

 * Role: Dependency Resolution & Package Availability.
 * Function: It tells Nix which commit hash (revision) of the home-manager source code to fetch. This dictates the version of the Nixpkgs (software binaries) and the available Nix modules (options like programs.git.enable).
 * Analogy: Similar to pointing a package.json to a specific library version or selecting a release channel (e.g., stable vs unstable) in a Linux distribution.
 * Update Policy: Should be updated regularly (via nix flake update) to receive security patches, bug fixes, and new features.

## 3. The Compatibility Layer: home.nix (State Version)

The home.stateVersion option acts as a feature flag for backward compatibility.
home.stateVersion = "25.05";

 * Role: Configuration Schema & Runtime Behavior.
 * Function: It instructs Home Manager on how to generate configuration files and file structures. Even if you are running the software from version 25.11 (defined in inputs), setting stateVersion to 25.05 forces Home Manager to replicate the file layout and default settings of the older version.
 * Why it exists: To prevent breaking changes. For example, if a newer version of Home Manager decides to move Zsh plugins from ~/.zsh/plugins to ~/.local/share/zsh, your shell setup would break immediately upon update. stateVersion prevents this shift until you explicitly opt-in.
 * Update Policy: Should be PINNED to the version used when the machine was first provisioned. Only update this value if you have read the release notes and are prepared to manually migrate configuration changes.

## 4. Technical Comparison

| Feature | inputs.home-manager.url (Flake) | home.stateVersion (Module) |
|---|---|---|
| Scope | External Dependencies (Binaries, Source Code) | Internal Logic (File Paths, Defaults) |
| Driver | The Nix Flake Resolver | The Home Manager Evaluation Engine |
| Impact | Determines what software is installed | Determines where and how configs are written |
| Risk | Low (mostly safe updates) | High (potential breaking changes in dotfiles) |
| Best Practice | Keep current (e.g., release-25.11) | Keep pinned (e.g., 25.05) |

## 5. Verification & Upgrade Protocol

Before modifying inputs or stateVersion, consult the official documentation to identify breaking changes.

### A. Where to Check
 * Home Manager Changes:
   * Source: The NEWS.adoc file in the GitHub repository or the "Release Notes" appendix in the Home Manager Manual.
   * Action: Search for the header corresponding to the target version (e.g., 25.11). Look for items marked as "Breaking Change" or instructions related to stateVersion.
   * URL: Home Manager Manual - Release Notes
 * Nixpkgs/NixOS Changes:
   * Source: The NixOS Release Notes.
   * Action: Since Home Manager modules often wrap NixOS packages, changes in underlying package names or option deprecations in NixOS will propagate to Home Manager.
   * URL: NixOS Release Notes

### B. Decision Matrix

| Scenario | Action Required | Verification Steps |
|---|---|---|
| Routine Maintenance | Run nix flake update | None. Safe operation. Updates binaries and minor module fixes. |
| Major Release Upgrade (e.g., 25.05 -> 25.11) | Update inputs in flake.nix | Required. Check if removed packages or renamed options affect your programs modules. |
| Migrating State | Update home.stateVersion | Critical. Read NEWS.adoc carefully. Verify if file paths (dotfiles) will move location. Backup data before applying. |
