
{ config, pkgs, inputs, ... }:

{

  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
  ];

  home.file.".local/share/color-schemes/MaterialYouDark.colors".source = ./MaterialYouDark.colors;

  home.username="pirkov";
  home.homeDirectory = "/home/pirkov";
  
  programs.kitty = {
    enable = true;   
    settings = {
      background = "#151313";
      foreground = "#e8e1e1";
      background_opacity = "0.66";
      background_blur = 1;
      hide_window_decorations = "yes";
    };
  };

  programs.plasma = {
     enable = true;

     workspace = {
	  iconTheme = "Gruvbox-Plus-Dark";
	  colorScheme = "MaterialYouDark";
	  cursor = {
		theme = "Breeze_Dark";
	};
	  splashScreen.theme = "org.kde.breeze.desktop";
	  wallpaper = ./wallpaper.png;
	};

     configFile = {
      "kdeglobals" = {
        "KDE" = { "widgetStyle" = "Breeze"; };
        "Sounds" = { "Theme" = "freedesktop"; };
      };
      
      "kwinrc" = {
        "org.kde.kdecoration2" = {
          "library" = "org.kde.breeze";
          "theme" = "breeze";
        };

        "Effect-overview" = {
          "BorderActivate" = 9;
      };
     };
    };

     


     shortcuts = {
      "kwin" = {
        "Window Close" = "Meta+Q";
        "Window Maximize" = "Meta+F";
      };

      "org.kde.krunnerrunnotregisteredcustomcommands" = {
        "kitty" = "Meta+Return";
      };

      "mediacontrol" = {
        "playpausemedia" = "ScrollLock";
        "nextmedia" = "Pause";
        "previousmedia" = "Print";
      };
    };

	};

  programs.home-manager.enable = true;

  home.stateVersion = "26.05";
}
