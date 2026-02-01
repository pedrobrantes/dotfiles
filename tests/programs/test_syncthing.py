def test_syncthing_service(home_manager_build):
    service_file = home_manager_build / "home-files/.config/systemd/user/syncthing.service"
    assert service_file.exists()
