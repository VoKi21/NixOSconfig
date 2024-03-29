{ config, pkgs, lib, inputs, ... }:
let
      download-images = pkgs.writeScriptBin "download-images" ''
        rm -rf slides-result
        mkdir slides-result
        cd slides-result
        for ((i = $2; i <= $3; i++)); do
	        echo $1$i
	        wget $1/$i
	        convert $i slide$(date +%s%3N).png
	        rm $i
        done
        convert slide*.png slides.pdf
        mv slides.pdf ../slides.pdf
        cd ..
        rm -rf slides-result
      '';
      run-bin = pkgs.writeScriptBin "run-bin" ''
        NIXPKGS_ALLOW_UNFREE=1 nix-shell -p steam-run --run "steam-run $@"  
      '';
      set-wallpaper = pkgs.writeScriptBin "set-wallpaper" ''
        swaybg -i ~/Pictures/Wallpapers/springarden/garden$(shuf -i 1-7 -n1).png
      '';
in {
  home = {
    username = "ralen";
    homeDirectory = "/home/ralen";
    stateVersion = "23.11";


    packages = with pkgs; [
      download-images
      run-bin
      set-wallpaper

      hello
      fastfetch
      telegram-desktop
      qbittorrent
      mpv
      steam
      wl-clipboard
      xfce.exo

      wofi
      rofi
      dmenu
      scrot
      slop
      i3status
      gwenview
      upscayl
      mate.mate-calc
      grim
      swappy
      slurp
      swaybg
      emote
      dialog
      pavucontrol
      btop

      lxqt.lxqt-policykit
      lxappearance-gtk2

      lutris
      itch
      prismlauncher
    ];

    

    sessionVariables = {
      EDITOR = "nvim";
      # LIBVA_DRIVER_NAME = "nvidia";
      # XDG_SESSION_TYPE = "wayland";
      # GBM_BACKEND = "nvidia-drm";
      # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      WLR_NO_HARDWARE_CURSORS = 1;
      # XCURSOR_SIZE = 24;
      # QT_QPA_PLATFORMTHEME = "qt6ct";
      # QT_STYLE_OVERRIDE = "kvantum";
    };

    pointerCursor = {
      gtk.enable = true;
      package = pkgs.google-cursor;
      name = "GoogleDot-Black";
      size = 24;
    };
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.layan-gtk-theme;
      name = "Layan-Dark";
    };

    iconTheme = {
      package = pkgs.fluent-icon-theme;
      name = "Fluent-dark";
    };

    font = {
      name = "Ubuntu";
      size = 12;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
    style = {
      package = pkgs.layan-kde;
      name = "gtk2";
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "steam"
      "lutris"
    ];
  };
  
  # imports = [ inputs.hyprland-nix.homeManagerMadules.default ];
  wayland.windowManager.hyprland = {
    enable = true;
    # reloadConfig = true;
    # systemIntegration = true;
    # nvidiaPatches = true;
    settings = {
      monitor = ",5120x1440@120,auto,1.0,vrr,1";

      exec = "set-wallpaper";
      exec-once = [
        "while :; do set-wallpaper & sleep 300; done"
        "emote"
        "lxqt-policykit-agent"
      ];
      
      "$mainMod" = "SUPER";
      "$terminal" = "kitty";
      "$fileManager" = "thunar";
      "$menu" = "wofi --show drun";

      input = {
        kb_layout = "lar_dv,cyr_dv";
        kb_options = "terminate:ctrl_alt_bksp,grp:alt_shift_toggle,lv3:ralt_switch,caps:escape";

        follow_mouse = 1;

        touchpad = {
          natural_scroll = 1;
        };
      };

      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 3;

        "col.active_border" = "rgba(6600aaee) rgba(0066aaee) rgba(aa0066ee) 45deg";
        "col.inactive_border" = "rgba(595959aa) rgba(74747450) 45deg";

        layout = "dwindle";
      };

      xwayland = {
        force_zero_scaling = 1;
      };

      decoration = {
        rounding = 15;

        blur = {
          enabled = 1;
          size = 3;
          passes = 2;
        };

        drop_shadow = 1;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };

      animations = {
        enabled = 1;

        bezier = [
          "steep, 0.05, 0.9, 0.1, 1.05"
          "linear, 0.0, 0.0, 1.0, 1.0"
          "smooth, 0.5, 0.1, 0.5, 1.5"
          "overshot, .39, .22, .25, 1.3"
        ];

        animation = [
          "windows, 1, 7, steep"
          "windowsOut, 1, 7, default, popin 80%"
          "borderangle, 1, 60, linear, loop"
          "fade, 1, 7, smooth"
          "workspaces, 1, 6, overshot, slidevert"
          "specialWorkspace, 1, 6, smooth, fade"
          "border, 1, 6, smooth"
        ];
      };
      dwindle = {
        pseudotile = 1;
        preserve_split = 1;
      };

      master = {
        new_is_master = 1;
      };

      misc = {
        force_default_wallpaper = -1;
        no_direct_scanout = 1;
      };

      windowrule = [
        "float, ^(org.kde.dolphin)$"
        "float, ^(thunar)$"
        "float,^(.*.exe)$"
        "float,^(steam_app_.*)$"
        "float,^(steam_proton)$"
        "float,^(lxqt-policykit-agent)$"
      ];

      windowrulev2 = [
        "float,class:^(kitty)$,title:^(nvim)$"
        "float,class:^(kitty)$,title:^(invoke.sh)$"
        # "nomaximizerequest, class:.*"
      ];

      bind = [
        "$mainMod, F, exec, xdg-open https://"
        "$mainMod, T, exec, telegram-desktop"
        "$mainMod, RETURN, exec, $terminal"
        "$mainMod, Q, killactive,"
        "$mainMod, C, exec, mate-calc"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, V, togglefloating,"
        "$mainMod, R, exec, $menu"
        "$mainMod, P, pseudo," # dwindle
        "$mainMod, J, togglesplit," # dwindle
        ", Print, exec, grim -g \"$(slurp)\" - | swappy -f -" # take a screenshot
        "CTRL, PERIOD, exec, emote"

        "$mainMod, F11, fullscreen"

        # Move focus with mainMod + arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        # Swap windows with mainMod + SHIFT + arrow keys
        "$mainMod SHIFT, left, swapwindow, l"
        "$mainMod SHIFT, right, swapwindow, r"
        "$mainMod SHIFT, up, swapwindow, u"
        "$mainMod SHIFT, down, swapwindow, d"

        # Example special workspace (scratchpad)
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"

        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ] ++ (
                # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList (
            x: let
              ws = let
                c = (x + 1) / 10;
              in
                builtins.toString (x + 1 - (c * 10));
            in [
              "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
              "$mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
          10)
      );

      binde = [
        "CTRL, up, exec, amixer -D pipewire sset Master 5%+"
        "CTRL, down, exec, amixer -D pipewire sset Master 5%-"

        # Resize windows with mainMod + CTRL + arrow keys
        "$mainMod CTRL, right, resizeactive, 20 0"
        "$mainMod CTRL, left, resizeactive, -20 0"
        "$mainMod CTRL, up, resizeactive, 0 -20"
        "$mainMod CTRL, down, resizeactive, 0 20"
      ];

      bindm = [
        ",mouse:275, movewindow"
        ",mouse:276, resizewindow"
      ];
    };
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;
        theme = "amuse";
        plugins = [
          "z"
          "git"
          "sudo"
        ];
      };
      shellAliases = {
        "update" = "nix flake update /home/ralen/.dotfiles/ & home-manager switch --flake /home/ralen/.dotfiles/ & sudo nixos-rebuild switch --flake /home/ralen/.dotfiles/";
        "hms" = "home-manager switch --flake /home/ralen/.dotfiles/";
        "nrs" = "sudo nixos-rebuild switch --flake /home/ralen/.dotfiles/";
      };
    };

    home-manager.enable = true;

    kitty = {
      enable = true;
      font = {
        name = "jetbrains mono nerd font";
        size = 15;
      };
      theme = "Wez";
      shellIntegration.enableZshIntegration = true;
      settings = {
        mouse_hide_wait = 2;
        confirm_os_window_close = 0;
        background_opacity = "0.7";
        shell = "zsh";
      };
    };
  };
}
