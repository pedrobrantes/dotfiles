def test_bash_it_configured(home_manager_build):
    """Verifies that Bash-it is configured in .bashrc."""
    bashrc = home_manager_build / "home-files/.bashrc"
    assert bashrc.exists()
    
    content = bashrc.read_text()
    assert "export BASH_IT=" in content
