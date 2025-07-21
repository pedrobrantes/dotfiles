{ config, pkgs, ... }:

{
  # Define a versão da configuração do home-manager.
  # Isso ajuda a garantir a compatibilidade futura.
  home.stateVersion = "25.05"; # Versão estável mais recente em 2025

  home.username = builtins.getEnv "USER";

  home.homeDirectory = builtins.getEnv "HOME";

  

  # Lista de pacotes que você quer instalar no seu perfil de usuário.
  home.packages = with pkgs; [
    # Exemplo: Adicione alguns utilitários básicos
    # ripgrep
    # fzf
    # eza
  ];

  # Configurações de programas (dotfiles)
  # Exemplo: Configuração básica do Git
  # programs.git = {
  #   enable = true;
  #   userName = "Seu Nome";
  #   userEmail = "seu-email@exemplo.com";
  #   extraConfig = {
  #     init.defaultBranch = "main";
  #   };
  # };

  # Exemplo: Configuração do Zsh
  # programs.zsh = {
  #   enable = true;
  #   shellAliases = {
  #     ll = "eza -l";
  #     la = "eza -la";
  #   };
  #   initExtra = ''
  #     # Comandos extras para o seu Zsh
  #     export EDITOR=nvim
  #   '';
  # };

  # Outras configurações...
}
