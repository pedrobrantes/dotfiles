{ config, ... }:

{
  # Fonte única de verdade para servidores MCP (compartilhada entre agy, opencode e futuros agentes).
  # Gera ~/.config/mcp/mcp.json e alimenta programs.opencode (enableMcpIntegration) e antigravity.nix.
  programs.mcp = {
    enable = true;

    servers = {
      # === Core (habilitados por padrão tanto no agy quanto no opencode) ===
      context7 = {
        url = "https://context7-mcp--upstash.run.tools";
      };
      fetch = {
        url = "https://server.smithery.ai/smithery-ai/fetch/mcp";
      };
      exa = {
        url = "https://exa.run.tools";
      };
      grep = {
        url = "https://grep--vercel.run.tools";
      };
      obsidian = {
        command = "npx";
        args = [
          "-y"
          "obsidian-mcp"
          "--path"
          "${config.home.homeDirectory}/Sync/Obsidian/My Notes"
        ];
      };

      # === Extras (habilitados no agy; desabilitados por padrão no opencode para economizar contexto) ===
      github = {
        url = "https://github.run.tools";
      };
      grokipedia = {
        url = "https://grokipedia-mcp--skymoore.run.tools";
      };
      reddit = {
        url = "https://reddit.run.tools";
      };
      instagram = {
        url = "https://instagram.run.tools";
      };
      linkedin = {
        url = "https://linkedin.run.tools";
      };
      facebook = {
        url = "https://facebook.run.tools";
      };
      discord = {
        url = "https://discord.run.tools";
      };
      discourse = {
        url = "https://discourse-forum-mcp--king-of-the-grackles.run.tools";
      };
      eventbrite = {
        url = "https://eventbrite.run.tools";
      };
      google-workspace = {
        url = "https://workspacemcp.googleapis.com/mcp/v1";
      };
      classroom = {
        url = "https://classroommcp.googleapis.com/mcp/v1";
      };
      google-developer-knowledge = {
        url = "https://developerknowledge.googleapis.com/mcp";
      };
      notion = {
        url = "https://notion.run.tools";
      };
      math = {
        url = "https://math-mcp--ethanhenrickson.run.tools";
      };
      audioscrape = {
        url = "https://audioscrape.run.tools";
      };
      rss-reader = {
        url = "https://rss-reader-mcp--kwp-lab.run.tools";
      };
      twitter = {
        url = "https://twitter.run.tools";
      };
      excel = {
        url = "https://excel.run.tools";
      };
      hackernews = {
        url = "https://hackernews.run.tools";
      };
      excalidraw = {
        url = "https://excalidraw.run.tools";
      };
      opengraph = {
        url = "https://opengraph--opengraph.run.tools";
      };
      anki = {
        command = "npx";
        args = [
          "-y"
          "@michaelfromin/anki-mcp"
        ];
      };
      paper-search = {
        url = "https://paper-search-mcp-openai--adamamer20.run.tools";
      };
      mem0 = {
        url = "https://mem0-memory-mcp--mem0ai.run.tools";
      };
      linkup = {
        url = "https://linkup-mcp-server--linkupplatform.run.tools";
      };
      huggingface = {
        url = "https://huggingface.run.tools";
      };
      supabase = {
        url = "https://supabase.run.tools";
      };
      figma = {
        url = "http://127.0.0.1:3845/mcp";
      };
      stripe = {
        url = "https://stripe.run.tools";
      };
    };
  };
}
