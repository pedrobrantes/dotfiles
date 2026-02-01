def test_gemini_installed(home_manager_build):
    assert (home_manager_build / "home-path/bin/gemini").exists()
