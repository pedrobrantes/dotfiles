# Usage Guide: Tailscale (Nix + Userspace)

This guide documents the configuration and workflow for **Tailscale** managed by Nix Home Manager, tailored for a multi-device setup (WSL and Android).

## 1. Architecture

### Desktop (WSL/Linux)
*   **Daemon (`tailscaled`)**: Managed as a `systemd` user service using `--tun=userspace-networking`.
*   **Mode**: Userspace networking (doesn't require root).
*   **Wrapper**: A smart `tailscale` function handles the socket path and automated Bitwarden login.

### Android (Termux/PRoot)
*   **Control Plane**: Handled by the official Tailscale Android App (required for OS-level VPN).
*   **Nix Package**: The `tailscale` binary is installed but cannot control the Android VPN due to sandboxing.
*   **Access**: Direct network access to other Tailnet nodes works seamlessly in the terminal once the App is active.

---

## 2. First-Time Setup (Desktop)

1.  **Add Auth Key to Bitwarden**:
    The Nix function expects an item named `tailscale-auth-key`.
    ```bash
    export BW_SESSION=$(bw unlock --raw)
    bw get template item | jq '.type=1 | .name="tailscale-auth-key" | .login={"password": "tskey-auth-..."}' | bw encode | bw create item
    ```

2.  **Activate Configuration**:
    ```bash
    ./switch.sh
    ```

3.  **Login**:
    ```bash
    tailscale up
    ```
    *The function will automatically fetch the key from Bitwarden.*

---

## 3. Workflow on Android

1.  **Install App**: Download Tailscale from Play Store/F-Droid.
2.  **Connect**: Switch to **Active** in the App.
3.  **Usage**: Access your desktop via its Tailscale IP or MagicDNS (e.g., `ssh brantes@desktop`).
    *   *Note*: `tailscale status` will not work inside Termux due to Android restrictions.

---

## 4. Troubleshooting

*   **Service not running (WSL)**: If `tailscale status` fails, ensure the service is active: `systemctl --user status tailscaled`.
*   **DNS Resolution**: Since we use userspace mode, the Tailscale IP will not appear in `ip addr`. Use `tailscale ip -4` to verify.
