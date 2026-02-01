import pytest
import subprocess
import os
import sys
from pathlib import Path

# Detect target architecture similar to switch.sh logic
def get_flake_target():
    arch = subprocess.check_output(["uname", "-m"]).decode().strip()
    
    # Simple detection logic aligned with switch.sh
    if os.path.exists("/data/data/com.termux") or os.path.exists("/system/build.prop"):
        os_name = "android"
        device = "smartphone"
    elif "Microsoft" in os.uname().release or "WSL" in os.uname().release:
        os_name = "wsl"
        device = "desktop"
    else:
        # Default fallback for standard Linux
        os_name = "linux"
        device = "desktop"

    return f"homeConfigurations.\"brantes@{arch}.{os_name}.{device}\".activationPackage"

@pytest.fixture(scope="session")
def home_manager_build(tmp_path_factory):
    """
    Builds the Home Manager configuration once per test session.
    Returns the Path to the build result.
    """
    target = get_flake_target()
    print(f"\n[setup] Building target: {target}")

    # Create a temporary directory for the build link
    out_link = tmp_path_factory.mktemp("build") / "result"

    cmd = [
        "nix", "build",
        "--extra-experimental-features", "nix-command flakes",
        f".#{target}",
        "--out-link", str(out_link)
    ]

    try:
        subprocess.run(cmd, check=True, capture_output=True)
    except subprocess.CalledProcessError as e:
        pytest.fail(f"Nix build failed:\n{e.stderr.decode()}")

    # Resolve the symlink to the actual store path
    real_path = out_link.resolve()
    print(f"[setup] Build successful at: {real_path}")
    
    return real_path
