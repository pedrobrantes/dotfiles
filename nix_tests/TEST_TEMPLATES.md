### Base Template

This is the clean structure to be used for all test files.

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "--> Testing: <program_name> <test_name>"
# <test_logic>
echo "OK: <program_name> <test_function> is correct."
```

-----

### Practical Examples

Here is how you implement the `<test_logic>` for common scenarios.

#### 1\. To Check if a Command Exists

This test verifies that the `nvim` executable is available in the `$PATH`.

**`nix_tests/tools/test_nvim_exists.sh`**

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "--> Testing: Neovim Installation"
if ! command -v nvim &> /dev/null; then
    echo "FAIL: nvim command not found." >&2
    exit 1
fi
echo "OK: nvim command is available in PATH."
```

#### 2\. To Check an Environment Variable's Value

This test verifies that the `$EDITOR` environment variable is set to `nvim`.

**`nix_tests/env/test_editor_variable.sh`**

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "--> Testing: Editor Environment Variable"
expected="nvim"
actual="${EDITOR:-not_set}"
if [[ "$actual" != "$expected" ]]; then
    echo "FAIL: EDITOR is '$actual', expected '$expected'." >&2
    exit 1
fi
echo "OK: EDITOR is set to nvim."
```

#### 3\. To Check if a Configuration File Exists

This test verifies that the git configuration file has been created at the expected path.

**`nix_tests/git/test_config_exists.sh`**

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "--> Testing: Git Config File Existence"
config_file="$HOME/.config/git/config"
if [[ ! -f "$config_file" ]]; then
    echo "FAIL: Git config file not found at $config_file." >&2
    exit 1
fi
echo "OK: Git config file exists."
```

#### 4\. To Check a File's Content

This test verifies that your name is correctly set inside the git config file.

**`nix_tests/git/test_user_name.sh`**

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "--> Testing: Git User Name"
config_file="$HOME/.config/git/config"
expected_line="name = Pedro Brantes"
if ! grep -q "$expected_line" "$config_file"; then
    echo "FAIL: User name not found or incorrect in $config_file." >&2
    exit 1
fi
echo "OK: Git user name is correct."
```
