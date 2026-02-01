def test_nix_config(home_manager_build):
    nix_conf = home_manager_build / "home-files/.config/nix/nix.conf"
    assert nix_conf.exists()
    assert "experimental-features = nix-command flakes" in nix_conf.read_text()
