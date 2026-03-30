# Guia de Uso: Tailscale (Nix + Userspace)

Este guia documenta a configuração e o fluxo de trabalho do **Tailscale** gerenciado pelo Nix Home Manager, adaptado para um ambiente multi-dispositivo (WSL e Android).

## 1. Arquitetura

### Desktop (WSL/Linux)
*   **Daemon (`tailscaled`)**: Gerenciado como um serviço de usuário do `systemd` usando `--tun=userspace-networking`.
*   **Modo**: Rede em espaço de usuário (não exige root/sudo).
*   **Wrapper**: Uma função `tailscale` inteligente gerencia o caminho do socket e o login automático via Bitwarden.

### Android (Termux/PRoot)
*   **Controle**: Realizado pelo Aplicativo Oficial do Tailscale para Android (necessário para criar a VPN no nível do SO).
*   **Pacote Nix**: O binário `tailscale` é instalado mas não consegue controlar a VPN do Android devido ao sandboxing do sistema.
*   **Acesso**: O acesso de rede a outros nós da Tailnet funciona perfeitamente no terminal assim que o App está ativo.

---

## 2. Configuração Inicial (Desktop)

1.  **Adicionar Chave ao Bitwarden**:
    A função Nix espera um item chamado `tailscale-auth-key`.
    ```bash
    export BW_SESSION=$(bw unlock --raw)
    bw get template item | jq '.type=1 | .name="tailscale-auth-key" | .login={"password": "tskey-auth-..."}' | bw encode | bw create item
    ```

2.  **Ativar Configuração**:
    ```bash
    ./switch.sh
    ```

3.  **Login**:
    ```bash
    tailscale up
    ```
    *A função buscará automaticamente a chave no Bitwarden.*

---

## 3. Fluxo de Trabalho no Android

1.  **Instalar App**: Baixe o Tailscale na Play Store ou F-Droid.
2.  **Conectar**: Ative o interruptor para **Active** no App.
3.  **Uso**: Acesse seu PC via IP do Tailscale ou MagicDNS (ex: `ssh brantes@desktop`).
    *   *Nota*: O comando `tailscale status` não funcionará dentro do Termux por restrições do Android.

---

## 4. Resolução de Problemas

*   **Serviço não roda (WSL)**: Se `tailscale status` falhar, verifique o serviço: `systemctl --user status tailscaled`.
*   **IP não aparece**: Como usamos o modo userspace, o IP do Tailscale não aparecerá no comando `ip addr` ou `ips`. Use `tailscale ip -4` para verificar.
