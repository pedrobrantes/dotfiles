{ pkgs, ... }:

{
  home.packages = [
    (pkgs.weechat.override {
      configure = { availablePlugins, ... }: {
        plugins = with availablePlugins; [
          (python.withPackages (ps: with ps; [
            pyopenssl
            matrix-client
            future
            dbus-python
          ]))
          lua
          perl
        ];
        scripts = with pkgs.weechatScripts; [
          weechat-matrix
        ];
      };
    })
  ];
}
