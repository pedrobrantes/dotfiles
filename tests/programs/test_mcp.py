import json


def test_mcp_config_generated(home_manager_build):
    """Verifies that the shared MCP configuration is generated."""
    mcp_file = home_manager_build / "home-files/.config/mcp/mcp.json"
    assert mcp_file.exists()

    data = json.loads(mcp_file.read_text())
    servers = data.get("mcpServers", {})
    assert "context7" in servers
    assert "fetch" in servers
    assert "obsidian" in servers
    assert "github" in servers
