# Guia de Uso: Devenv + Direnv

Este guia documenta a configuração e o fluxo de trabalho para ambientes de desenvolvimento declarativos utilizando **devenv** e **direnv** no seu sistema.

## 1. O que é o quê?

*   **devenv**: Define *o que* o seu projeto precisa (Python, Rust, Postgres, scripts de build). É o arquivo `devenv.nix`.
*   **direnv**: É o "gatilho". Ele detecta o arquivo `.envrc` e ativa o ambiente do devenv automaticamente assim que você entra na pasta.

---

## 2. Sintaxe do `devenv.nix`

O arquivo `devenv.nix` é onde a mágica acontece. Aqui estão os blocos principais:

```nix
{ pkgs, ... }: {
  # Variáveis de Ambiente
  env.PROJECT_NAME = "Meu Projeto";

  # Pacotes do Nixpkgs (disponíveis apenas neste shell)
  packages = [ pkgs.jq pkgs.ripgrep ];

  # Linguagens (Abstrações de alto nível)
  languages.python = {
    enable = true;
    uv.enable = true; # Integração com uv
  };
  
  languages.rust.enable = true;

  # Scripts personalizados (criam binários no PATH do shell)
  scripts.limpar.exec = "rm -rf target/ dist/";

  # Serviços (Bancos de dados que sobem em background)
  services.postgres.enable = true;

  # Comandos executados ao entrar no shell
  enterShell = ''
    echo "Bem-vindo ao ambiente $PROJECT_NAME"
    python --version
  '';
}
```

---

## 3. Integração com Direnv (Automática)

Sua configuração no Home Manager (`programs/direnv.nix`) inclui uma função customizada no `stdlib` chamada `use_devenv`.

### Como funciona internamente:
```bash
use_devenv() {
  watch_file devenv.nix    # Recarrega o shell se você editar o nix
  watch_file devenv.yaml   # Recarrega o shell se as inputs mudarem
  eval "$(devenv print-dev-env)" # Exporta o ambiente para o seu shell atual
}
```

Para ativar em um projeto, o arquivo `.envrc` deve conter apenas:
```bash
use devenv
```

---

## 4. Workflow de Desenvolvimento

1.  **Iniciar um projeto:**
    ```bash
    mkdir meu-projeto && cd meu-projeto
    devenv init
    ```
2.  **Autorizar o ambiente:**
    ```bash
    direnv allow
    ```
3.  **Adicionar ferramentas:**
    Edite o `devenv.nix`, salve o arquivo e o `direnv` aplicará as mudanças instantaneamente.
4.  **Serviços em Background:**
    Se você habilitou `services`, use:
    ```bash
    devenv up
    ```

---

## 5. Dicas Importantes (Aarch64/Android)

*   **Cache:** A primeira ativação de um ambiente novo pode demorar alguns minutos para baixar/compilar as dependências.
*   **Comandos não encontrados:** Se o `direnv` reclamar que não achou o `devenv`, certifique-se de que o `switch.sh` foi executado após as mudanças no `direnv.nix`.
