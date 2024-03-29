    config = rec {
      modifier = "Mod4";
      bars = [ ];

      window.border = 0;

      keybindings = lib.mkOptionDefault {
        "${modifier}+Return" = "exec kitty";
        "${modifier}+r" = "exec rofi -modi drun -show drun";
        "${modifier}+Shift+d" = "exec rofi -show window";
        "${modifier}+y" = "exec firefox";
        "${modifier}+k" = "exec telegram-desktop";
        "${modifier}+p" = "exec lutris";
        "${modifier}+d" = "exec dolphin";
        "${modifier}+semicolon" = "exec steam";
        "${modifier}+Shift+x" = "exec systemctl suspend";
        "${modifier}+q" = "kill";
        "Ctrl+Up" = "exec --no-tartup-id amixer -D pipewire sset Master 5%+ && $refresh_i3status";
        "Ctrl+Down" = "exec --no-tartup-id amixer -D pipewire sset Master 5%- && $refresh_i3status";
      }

      startup = [
        {
          command = "exec --no-startup-id setxkbmap -option terminate:ctrl_alt_bksp,grp:alt_shift_toggle,lv3:ralt_switch,caps:escape lar,lar_dv";
          always = true;
          notification = false;
        }
        {
          command = "exec xrandr --output DP-0 --mode 5120x1440";
          always = true;
          notification = false;
        }
        {
          command = "exec --no-startup-id dex --autostart --environment i3";
          always = true;
          notification = false;
        }
      ];
    };

