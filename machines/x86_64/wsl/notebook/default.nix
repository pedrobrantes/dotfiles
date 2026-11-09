{ config, pkgs, lib, ... }:

{
  imports = [ ../../../../home.nix ];

  home.username = "brantes";
  home.homeDirectory = "/home/brantes";

  sops.defaultSopsFile = ../../../../secrets/secrets.yaml;
  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

  # Chave SSH própria do notebook (mais seguro do que reutilizar a do desktop)
  sops.secrets."ssh_keys/notebook" = {
    path = "${config.home.homeDirectory}/.ssh/id_ed25519";
    mode = "0600";
  };


  programs.bash.shellAliases = {
    # === WSL / Windows aliases ===
    explorer     = "explorer.exe";
    winget       = "winget.exe";
    notepad      = "notepad.exe";
    regedit      = "sudo.exe regedit.exe";
    "gpedit.msc" = "eval cmd.exe /C gpedit.msc";
    gpedit       = "eval cmd.exe /C gpedit.msc";
    bluetooth    = "fsquirt.exe";
    fsquirt      = "fsquirt.exe";
    ipconfig     = "ipconfig.exe";
    netsh        = "sudo.exe netsh.exe";
    "WF.msc"     = "eval cmd.exe /C WF.msc";
    wf           = "eval cmd.exe /C WF.msc";
    taskmgr      = "Taskmgr.exe";
    "taskschd.msc" = "eval cmd.exe /C taskschd.msc";
    taskschd     = "eval cmd.exe /C taskschd.msc";
    calc         = "calc.exe";
    control      = "control.exe";
    defrag       = "Defrag.exe";
    diskpart     = "sudo.exe diskpart.exe";
    diskusage    = "sudo.exe diskusage.exe";
    findstr      = "findstr.exe";
    label        = "label.exe";
    livecaptions = "LiveCaptions.exe";
    everything   = "$WIN_PROGRAM_FILES/everything/everything.exe";
    powertoys    = "$WIN_PROGRAM_FILES/PowerToys/PowerToys.exe";
    PowerToys    = "$WIN_PROGRAM_FILES/PowerToys/PowerToys.exe";
    "powertoys.colorpicker"  = "$WIN_PROGRAM_FILES/PowerToys/PowerToys.ColorPickerUI.exe";
    colorpicker              = "$WIN_PROGRAM_FILES/PowerToys/PowerToys.ColorPickerUI.exe";
    "powertoys.workspaces"   = "$WIN_PROGRAM_FILES/PowerToys/PowerToys.WorkspacesEditor.exe";
    workspaces               = "$WIN_PROGRAM_FILES/PowerToys/PowerToys.WorkspacesEditor.exe";
    "powertoys.fancyzones"   = "$WIN_PROGRAM_FILES/PowerToys/PowerToys.FancyZones.exe";
    fancyzones               = "$WIN_PROGRAM_FILES/PowerToys/PowerToys.FancyZones.exe";
    "powertoys.env"          = "$WIN_PROGRAM_FILES/PowerToys/WinUI3Apps/PowerToys.EnvironmentVariables.exe";
    environmentvariables     = "$WIN_PROGRAM_FILES/PowerToys/WinUI3Apps/PowerToys.EnvironmentVariables.exe";
    "powertoys.measuretool"  = "$WIN_PROGRAM_FILES/PowerToys/WinUI3Apps/PowerToys.MeasureToolUI.exe";
    measuretool              = "$WIN_PROGRAM_FILES/PowerToys/WinUI3Apps/PowerToys.MeasureToolUI.exe";
    "powertoys.hosts"        = "$WIN_PROGRAM_FILES/PowerToys/WinUI3Apps/PowerToys.Hosts.exe";
    hosts                    = "$WIN_PROGRAM_FILES/PowerToys/WinUI3Apps/PowerToys.Hosts.exe";
  };

  # Tailscale como serviço userspace (igual ao desktop)
  programs.custom-tailscale.enableService = true;

  # Docker CLI para dev com containers
  programs.custom-docker-cli.enable = true;

  # Ollama desabilitado: sem GPU dedicada (apenas iGPU 1GB) e espaço limitado.
  # Para rodar LLMs locais, use SSH no desktop com RTX.
  # programs.custom-ollama.enable = false; # padrão já é false

  # === Ferramentas de Dados / Analytics Engineering ===
  home.packages = with pkgs; [
    # SQL analítico local — leitura de CSV, Parquet, JSON sem banco de dados
    duckdb

    # Google Cloud Platform: gcloud, bq (BigQuery CLI), gsutil (Cloud Storage)
    google-cloud-sdk

    # Infrastructure as Code (open-source Terraform fork)
    # Útil para provisionar BigQuery datasets, GCS buckets, Dataform, etc.
    opentofu

    # Análise tabular interativa no terminal — CSV, Parquet, JSON, SQLite, etc.
    visidata

    # PostgreSQL CLI com autocomplete inteligente e syntax highlighting
    pgcli

    # HTTP client rápido (compatível com HTTPie, mas em Rust)
    # Ótimo para testar APIs REST de data platforms
    xh
  ];

  # authorized_keys: aceita conexões do desktop, smartphone, tablet e do próprio notebook
  sops.secrets."ssh_public_keys/desktop"    = { };
  sops.secrets."ssh_public_keys/smartphone" = { };
  sops.secrets."ssh_public_keys/tablet"     = { };
  sops.secrets."ssh_public_keys/notebook"   = { };

  sops.templates."authorized_keys" = {
    content = ''
      ${config.sops.placeholder."ssh_public_keys/desktop"}
      ${config.sops.placeholder."ssh_public_keys/smartphone"}
      ${config.sops.placeholder."ssh_public_keys/tablet"}
      ${config.sops.placeholder."ssh_public_keys/notebook"}
    '';
    path = "${config.home.homeDirectory}/.ssh/authorized_keys";
    mode = "0600";
  };
}
