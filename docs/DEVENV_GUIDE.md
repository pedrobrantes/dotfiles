# Usage Guide: Devenv + Direnv

This guide documents the configuration and workflow for declarative development environments using **devenv** and **direnv** on your system.

## 1. What is what?

*   **devenv**: Defines *what* your project needs (Python, Rust, Postgres, build scripts). It is the `devenv.nix` file.
*   **direnv**: It's the "trigger". It detects the `.envrc` file and automatically activates the devenv environment as soon as you enter the folder.

---

## 2. `devenv.nix` Syntax

The `devenv.nix` file is where the magic happens. Here are the main blocks:

```nix
{ pkgs, ... }: {
  # Environment Variables
  env.PROJECT_NAME = "My Project";

  # Nixpkgs packages (available only in this shell)
  packages = [ pkgs.jq pkgs.ripgrep ];

  # Languages (High-level abstractions)
  languages.python = {
    enable = true;
    uv.enable = true; # uv integration
  };
  
  languages.rust.enable = true;

  # Custom scripts (create binaries in the shell's PATH)
  scripts.clean.exec = "rm -rf target/ dist/";

  # Services (Background databases/queues)
  services.postgres.enable = true;

  # Commands executed when entering the shell
  enterShell = ''
    echo "Welcome to the $PROJECT_NAME environment"
    python --version
  '';
}
```

---

## 3. Direnv Integration (Automatic)

Your Home Manager configuration (`programs/direnv.nix`) includes a custom function in `stdlib` called `use_devenv`.

### How it works internally:
```bash
use_devenv() {
  watch_file devenv.nix    # Reload shell if nix file is edited
  watch_file devenv.yaml   # Reload shell if inputs change
  eval "$(devenv print-dev-env)" # Exports environment to your current shell
}
```

To activate in a project, the `.envrc` file should only contain:
```bash
use devenv
```

---

## 4. Development Workflow

1.  **Initialize a project:**
    ```bash
    mkdir my-project && cd my-project
    devenv init
    ```
2.  **Authorize the environment:**
    ```bash
    direnv allow
    ```
3.  **Add tools:**
    Edit `devenv.nix`, save the file, and `direnv` will apply changes instantly.
4.  **Background Services:**
    If you enabled `services`, use:
    ```bash
    devenv up
    ```

---

## 5. Important Tips (Aarch64/Android)

*   **Cache:** The first activation of a new environment may take a few minutes to download/compile dependencies.
*   **Commands not found:** If `direnv` complains it can't find `devenv`, ensure `switch.sh` was executed after changes to `direnv.nix`.
