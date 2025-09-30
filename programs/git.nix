{ config, pkgs, ... }:

{
  home.packages = [ 
    pkgs.git
    pkgs.delta
  ];

  programs.git = {
    enable = true;
    userName = "PedroBrantes";
    userEmail = "58346706+PedroBrantes@users.noreply.github.com";

    extraConfig = {
      # Credential helpers
      "credential \"https://github.com\"".helper = "!/usr/bin/gh auth git-credential";
      "credential \"https://gist.github.com\"".helper = "!/usr/bin/gh auth git-credential";

      # Core settings
      core.pager = "delta";

      # Interactive settings
      interactive.diffFilter = "delta --color-only";

      # Delta settings
      delta.navigate = "true";
      delta.line-numbers = "true";
      delta.syntax-theme = "gruvbox-dark";
      delta.dark = "true";

      # Merge settings
      merge.conflictstyle = "diff3";

      # Diff settings
      diff.colorMoved = "default";

      # Oh-my-zsh related
      "oh-my-zsh"."git-commit-alias" = "668ca3a32dae5ff5d164fc3be565f1e2ece248db";

      # Complex aliases
      alias.build = ''
        !a() {
          local _scope _attention _message
          while [ $$# -ne 0 ]; do
            case $$1 in
              -s | --scope )
                if [ -z $$2 ]; then
                  echo \"Missing scope!\"
                  return 1
                fi 
                _scope=\"$$2\"
                shift 2 
                ;;
              -a | --attention )
                _attention=\"!\"
                shift 1 
                ;;
              * )
                _message=\"$${_message} $$1\"
                shift 1
                ;;
            esac
          done
          git commit -m \"build$${_scope:+($${_scope})}$${_attention}:$${_message}\"
        }; a
      '';
      alias.chore = ''
        !a() {
          local _scope _attention _message
          while [ $$# -ne 0 ]; do
            case $$1 in
              -s | --scope )
                if [ -z $$2 ]; then
                  echo \"Missing scope!\"
                  return 1
                fi
                _scope=\"$$2\"
                shift 2
                ;;
              -a | --attention )
                _attention=\"!\"
                shift 1
                ;;
              * )
                _message=\"$${_message} $$1\"
                shift 1
                ;;
            esac
          done
          git commit -m \"chore$${_scope:+($${_scope})}$${_attention}:$${_message}\"
        }; a
      '';
      alias.ci = ''
        !a() {
          local _scope _attention _message
          while [ $$# -ne 0 ]; do
            case $$1 in
              -s | --scope )
                if [ -z $$2 ]; then
                  echo \"Missing scope!\"
                  return 1
                fi
                _scope=\"$$2\"
                shift 2
                ;;
              -a | --attention )
                _attention=\"!\"
                shift 1
                ;;
              * )
                _message=\"$${_message} $$1\"
                shift 1
                ;;
            esac
          done
          git commit -m \"ci$${_scope:+($${_scope})}$${_attention}:$${_message}\"
        }; a
      '';
      alias.docs = ''
        !a() {
          local _scope _attention _message
          while [ $$# -ne 0 ]; do
            case $$1 in
              -s | --scope )
                if [ -z $$2 ]; then
                  echo \"Missing scope!\"
                  return 1
                fi
                _scope=\"$$2\"
                shift 2
                ;;
              -a | --attention )
                _attention=\"!\"
                shift 1
                ;;
              * )
                _message=\"$${_message} $$1\"
                shift 1
                ;;
            esac
          done
          git commit -m \"docs$${_scope:+($${_scope})}$${_attention}:$${_message}\"
        }; a
      '';
      alias.feat = ''
        !a() {
          local _scope _attention _message
          while [ $$# -ne 0 ]; do
            case $$1 in
              -s | --scope )
                if [ -z $$2 ]; then
                  echo \"Missing scope!\"
                  return 1
                fi
                _scope=\"$$2\"
                shift 2
                ;;
              -a | --attention )
                _attention=\"!\"
                shift 1
                ;;
              * )
                _message=\"$${_message} $$1\"
                shift 1
                ;;
            esac
          done
          git commit -m \"feat$${_scope:+($${_scope})}$${_attention}:$${_message}\"
        }; a
      '';
      alias.fix = ''
        !a() {
          local _scope _attention _message
          while [ $$# -ne 0 ]; do
            case $$1 in
              -s | --scope )
                if [ -z $$2 ]; then
                  echo \"Missing scope!\"
                  return 1
                fi
                _scope=\"$$2\"
                shift 2
                ;;
              -a | --attention )
                _attention=\"!\"
                shift 1
                ;;
              * )
                _message=\"$${_message} $$1\"
                shift 1
                ;;
            esac
          done
          git commit -m \"fix$${_scope:+($${_scope})}$${_attention}:$${_message}\"
        }; a
      '';
      alias.perf = ''
        !a() {
          local _scope _attention _message
          while [ $$# -ne 0 ]; do
            case $$1 in
              -s | --scope )
                if [ -z $$2 ]; then
                  echo \"Missing scope!\"
                  return 1
                fi
                _scope=\"$$2\"
                shift 2
                ;;
              -a | --attention )
                _attention=\"!\"
                shift 1
                ;;
              * )
                _message=\"$${_message} $$1\"
                shift 1
                ;;
            esac
          done
          git commit -m \"perf$${_scope:+($${_scope})}$${_attention}:$${_message}\"
        }; a
      '';
      alias.refactor = ''
        !a() {
          local _scope _attention _message
          while [ $$# -ne 0 ]; do
            case $$1 in
              -s | --scope )
                if [ -z $$2 ]; then
                  echo \"Missing scope!\"
                  return 1
                fi
                _scope=\"$$2\"
                shift 2
                ;;
              -a | --attention )
                _attention=\"!\"
                shift 1
                ;;
              * )
                _message=\"$${_message} $$1\"
                shift 1
                ;;
            esac
          done
          git commit -m \"refactor$${_scope:+($${_scope})}$${_attention}:$${_message}\"
        }; a
      '';
      alias.rev = ''
        !a() {
          local _scope _attention _message
          while [ $$# -ne 0 ]; do
            case $$1 in
              -s | --scope )
                if [ -z $$2 ]; then
                  echo \"Missing scope!\"
                  return 1
                fi
                _scope=\"$$2\"
                shift 2
                ;;
              -a | --attention )
                _attention=\"!\"
                shift 1
                ;;
              * )
                _message=\"$${_message} $$1\"
                shift 1
                ;;
            esac
          done
          git commit -m \"rev$${_scope:+($${_scope})}$${_attention}:$${_message}\"
        }; a
      '';
      alias.style = ''
        !a() {
          local _scope _attention _message
          while [ $$# -ne 0 ]; do
            case $$1 in
              -s | --scope )
                if [ -z $$2 ]; then
                  echo \"Missing scope!\"
                  return 1
                fi
                _scope=\"$$2\"
                shift 2
                ;;
              -a | --attention )
                _attention=\"!\"
                shift 1
                ;;
              * )
                _message=\"$${_message} $$1\"
                shift 1
                ;;
            esac
          done
          git commit -m \"style$${_scope:+($${_scope})}$${_attention}:$${_message}\"
        }; a
      '';
      alias.test = ''
        !a() {
          local _scope _attention _message
          while [ $$# -ne 0 ]; do
            case $$1 in
              -s | --scope )
                if [ -z $$2 ]; then
                  echo \"Missing scope!\"
                  return 1
                fi
                _scope=\"$$2\"
                shift 2
                ;;
              -a | --attention )
                _attention=\"!\"
                shift 1
                ;;
              * )
                _message=\"$${_message} $$1\"
                shift 1
                ;;
            esac
          done
          git commit -m \"test$${_scope:+($${_scope})}$${_attention}:$${_message}\"
        }; a
      '';
      alias.wip = ''
        !a() {
          local _scope _attention _message
          while [ $$# -ne 0 ]; do
            case $$1 in
              -s | --scope )
                if [ -z $$2 ]; then
                  echo \"Missing scope!\"
                  return 1
                fi
                _scope=\"$$2\"
                shift 2
                ;;
              -a | --attention )
                _attention=\"!\"
                shift 1
                ;;
              * )
                _message=\"$${_message} $$1\"
                shift 1
                ;;
            esac
          done
          git commit -m \"wip$${_scope:+($${_scope})}$${_attention}:$${_message}\"
        }; a
      '';
    };

    # Aliases
    aliases = {
    };
  };
}
