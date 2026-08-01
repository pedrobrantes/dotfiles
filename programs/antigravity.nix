{ pkgsUnstable, config, ... }:

{
  home.packages = [
    pkgsUnstable.antigravity-cli
  ];

  # Antigravity-cli configurations in ~/.gemini/antigravity-cli/
  home.file.".gemini/antigravity-cli/settings.json".text = builtins.toJSON {
    security = {
      auth = {
        selectedType = "oauth-personal";
      };
    };
    general = {
      previewFeatures = true;
    };
    trustedWorkspaces = [
      "${config.home.homeDirectory}/.config/home-manager"
      config.home.homeDirectory
    ];
  };

  # Antigravity MCP configuration in ~/.gemini/antigravity-cli/mcp_config.json
  home.file.".gemini/antigravity-cli/mcp_config.json".text = builtins.toJSON {
    mcpServers = {
      fetch = {
        serverUrl = "https://server.smithery.ai/smithery-ai/fetch/mcp";
      };
      github = {
        serverUrl = "https://github.run.tools";
      };
      context7 = {
        serverUrl = "https://context7-mcp--upstash.run.tools";
      };
      grokipedia = {
        serverUrl = "https://grokipedia-mcp--skymoore.run.tools";
      };
      reddit = {
        serverUrl = "https://reddit.run.tools";
      };
      instagram = {
        serverUrl = "https://instagram.run.tools";
      };
      linkedin = {
        serverUrl = "https://linkedin.run.tools";
      };
      facebook = {
        serverUrl = "https://facebook.run.tools";
      };
      discord = {
        serverUrl = "https://discord.run.tools";
      };
      discourse = {
        serverUrl = "https://discourse-forum-mcp--king-of-the-grackles.run.tools";
      };
      eventbrite = {
        serverUrl = "https://eventbrite.run.tools";
      };
      gmail = {
        serverUrl = "https://gmail.run.tools";
      };
      google-calendar = {
        serverUrl = "https://googlecalendar.run.tools";
      };
      google-maps = {
        serverUrl = "https://google_maps.run.tools";
      };
      notion = {
        serverUrl = "https://notion.run.tools";
      };
      math = {
        serverUrl = "https://math-mcp--ethanhenrickson.run.tools";
      };
      audioscrape = {
        serverUrl = "https://audioscrape.run.tools";
      };
      rss-reader = {
        serverUrl = "https://rss-reader-mcp--kwp-lab.run.tools";
      };
      twitter = {
        serverUrl = "https://twitter.run.tools";
      };
      excel = {
        serverUrl = "https://excel.run.tools";
      };
      hackernews = {
        serverUrl = "https://hackernews.run.tools";
      };
      excalidraw = {
        serverUrl = "https://excalidraw.run.tools";
      };
      exa = {
        serverUrl = "https://exa.run.tools";
      };
      opengraph = {
        serverUrl = "https://opengraph--opengraph.run.tools";
      };
      youtube = {
        serverUrl = "https://youtube.run.tools";
      };
      gemini = {
        serverUrl = "https://gemini.run.tools";
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
        serverUrl = "https://paper-search-mcp-openai--adamamer20.run.tools";
      };
      mem0 = {
        serverUrl = "https://mem0-memory-mcp--mem0ai.run.tools";
      };
      linkup = {
        serverUrl = "https://linkup-mcp-server--linkupplatform.run.tools";
      };
      grep = {
        serverUrl = "https://grep--vercel.run.tools";
      };
      huggingface = {
        serverUrl = "https://huggingface.run.tools";
      };
      supabase = {
        serverUrl = "https://supabase.run.tools";
      };
      figma = {
        serverUrl = "http://127.0.0.1:3845/mcp";
      };
      stripe = {
        serverUrl = "https://stripe.run.tools";
      };
    };
  };

  # Also alias to ~/.gemini/config/mcp_config.json for global Antigravity discovery
  home.file.".gemini/config/mcp_config.json".text = config.home.file.".gemini/antigravity-cli/mcp_config.json".text;
}
