# SOPS Secrets Management Protocol

## 1. Prerequisites

Ensure the `age` private identity key is accessible to the SOPS CLI.
The default expected location is:
`$HOME/.config/sops/age/keys.txt`

## 2. Workflow Overview

1.  **Edit**: Update the encrypted vault.
2.  **Declare**: Register the secret in the Nix configuration.
3.  **Consume**: Access the decrypted secret path in the runtime environment.

## 3. Editing the Vault

To add or modify secrets, open the encrypted store using the SOPS binary. Do not use standard text editors.

```bash
sops secrets/secrets.yaml

# Add the new secret key-value pair using standard YAML syntax.
ssh_keys:
  desktop: |
    -----BEGIN OPENSSH PRIVATE KEY-----
    ...
  smartphone: |
    -----BEGIN OPENSSH PRIVATE KEY-----
    ...

my_new_service:
  api_token: "xoxb-1234567890"
```

## 4. Declaration in Nix

Register the secret in the appropriate Nix module.

### A. Global/Shared Secrets

For secrets used by common programs, modify the specific program module (e.g., programs/myservice.nix) or programs/sops.nix.

```nix
{ config, ... }:

{
  sops.secrets."my_new_service/api_token" = {
    sopsFile = ../secrets/secrets.yaml;
  };
}
```

### B. Machine-Specific Secrets

For infrastructure secrets, modify the machine definition (e.g., machines/x86_64/wsl/desktop/default.nix).

```nix
{ config, ... }:

{
  sops.secrets."infrastructure/specific_key" = {
    sopsFile = ../../../../secrets/secrets.yaml;
    path = "${config.home.homeDirectory}/.config/service/key.pem";
  };
}
```

### 5. Consumption

Secrets are decrypted at runtime into a read-only file. Access them via config.sops.secrets.<name>.path.
Example: Injecting into Environment Variables

```nix
{ config, ... }:

{
  home.sessionVariables = {
    SERVICE_TOKEN_FILE = config.sops.secrets."my_new_service/api_token".path;
  };
}
```
