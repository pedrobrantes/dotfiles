{ pkgsUnstable, config, ... }:

{
  home.packages = [
    pkgsUnstable.gemini-cli
  ];

  # Gemini-cli configurations in ~/.gemini/
  home.file.".gemini/settings.json".text = builtins.toJSON {
    security = {
      auth = {
        selectedType = "oauth-personal";
      };
    };
    general = {
      previewFeatures = true;
    };
    mcpServers = {
      fetch = {
        httpUrl = "https://server.smithery.ai/smithery-ai/fetch/mcp";
      };
      github = {
        httpUrl = "https://github.run.tools";
      };
      context7 = {
        httpUrl = "https://context7-mcp--upstash.run.tools";
      };
      grokipedia = {
        httpUrl = "https://grokipedia-mcp--skymoore.run.tools";
      };
      reddit = {
        httpUrl = "https://reddit.run.tools";
      };
      instagram = {
        httpUrl = "https://instagram.run.tools";
      };
      facebook = {
        httpUrl = "https://facebook.run.tools";
      };
      discord = {
        httpUrl = "https://discord.run.tools";
      };
      gmail = {
        httpUrl = "https://gmail.run.tools";
      };
      twitter = {
        httpUrl = "https://twitter.run.tools";
      };
      excel = {
        httpUrl = "https://excel.run.tools";
      };
      hackernews = {
        httpUrl = "https://hackernews.run.tools";
      };
      excalidraw = {
        httpUrl = "https://excalidraw.run.tools";
      };
      exa = {
        httpUrl = "https://exa.run.tools";
      };
      youtube = {
        httpUrl = "https://youtube.run.tools";
      };
      gemini = {
        httpUrl = "https://gemini.run.tools";
      };
      anki = {
        command = "npx";
        args = [ "-y" "@michaelfromin/anki-mcp" ];
      };
      obsidian = {
        command = "npx";
        args = [ "-y" "obsidian-mcp" "--path" "${config.home.homeDirectory}/Sync/Obsidian/My Notes" ];
      };
      paper-search = {
        httpUrl = "https://paper-search-mcp-openai--adamamer20.run.tools";
      };
      mem0 = {
        httpUrl = "https://mem0-memory-mcp--mem0ai.run.tools";
      };
      linkup = {
        httpUrl = "https://linkup-mcp-server--linkupplatform.run.tools";
      };
    };
  };

  home.file.".gemini/projects.json".text = builtins.toJSON {
    projects = {
      "${config.home.homeDirectory}" = "brantes";
    };
  };

  home.file.".gemini/trustedFolders.json".text = builtins.toJSON {
    "${config.home.homeDirectory}" = "TRUST_FOLDER";
  };
}
