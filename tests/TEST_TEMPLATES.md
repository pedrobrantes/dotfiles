# Test Templates (Python/Pytest)

We use **Pytest** for integration testing. All tests are located in the `tests/` directory.
A global fixture `home_manager_build` (defined in `tests/conftest.py`) builds the Home Manager configuration once and returns the path to the result.

### Base Template

Create a new file `tests/programs/test_<program_name>.py`.

```python
def test_<program_name>_installed(home_manager_build):
    """Verifies that the program binary is installed."""
    # The 'home_manager_build' fixture is the Path to the build result
    binary = home_manager_build / "home-path/bin/<binary_name>"
    
    assert binary.exists()
    assert binary.is_file()
```

-----

### Practical Examples

#### 1. Checking for a Binary

This test checks if `nvim` is installed in the environment.

**`tests/programs/test_neovim.py`**

```python
def test_neovim_installed(home_manager_build):
    nvim_bin = home_manager_build / "home-path/bin/nvim"
    assert nvim_bin.exists()
```

#### 2. Checking Configuration File Content

This verifies that the Git config file contains a specific string.

**`tests/programs/test_git.py`**

```python
def test_git_user_name(home_manager_build):
    # Note: Configuration files are usually linked in 'home-files'
    git_config = home_manager_build / "home-files/.config/git/config"
    
    assert git_config.exists()
    
    content = git_config.read_text()
    assert "name = Pedro Brantes" in content
```

#### 3. Checking Aliases in .bashrc

Since aliases are often functions or exports in `.bashrc`, we check the content of that file.

**`tests/programs/test_aliases.py`**

```python
def test_bat_alias(home_manager_build):
    bashrc = home_manager_build / "home-files/.bashrc"
    content = bashrc.read_text()
    
    # Check for the alias definition
    assert 'alias cat="bat"' in content
```