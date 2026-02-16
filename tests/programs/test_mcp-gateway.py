def test_mcp_gateway_installed(home_manager_build):
    """Verifies that mcp-gateway is installed."""
    bin_path = home_manager_build / "home-path/bin/mcp-gateway"
    assert bin_path.exists()
