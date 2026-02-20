def test_sqlite_installed(home_manager_build):
    """Verifies that sqlite3 binary is installed."""
    sqlite_bin = home_manager_build / "home-path/bin/sqlite3"
    assert sqlite_bin.exists()
