def test_transmission_installed(home_manager_build):
    """Verifies transmission and tremc installation."""
    # Transmission package usually provides transmission-daemon, transmission-cli, etc.
    # We check for the daemon or cli.
    trans_bin = home_manager_build / "home-path/bin/transmission-daemon"
    tremc_bin = home_manager_build / "home-path/bin/tremc"
    
    assert trans_bin.exists()
    assert tremc_bin.exists()
