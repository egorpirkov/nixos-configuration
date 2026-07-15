# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual ().

{ config, lib, pkgs, inputs, ... }:

{
  imports = [ 
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.spicetify-nix.nixosModules.default
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  

  environment.sessionVariables = { };

  fileSystems."/mnt/HDD" =
    { device = "/dev/disk/by-uuid/54164484164468D6";
      fsType = "ntfs3";
      options = [ "uid=1000" "gid=100" "dmask=0022" "fmask=0022" "nofail" ];
    };

  # Allow unfree software
  nixpkgs.config.allowUnfree = true;


  
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  boot.kernelParams = [
   "nvidia-drm.modeset=1"
   "nvidia-drm.fbdev=1"
	];

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.hostName = "nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Almaty";

  # nvidia drivers
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    powerManagement.enable = true;
    # legacy branch
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  };

  programs.spicetify = {
    enable = true;
    enabledExtensions = with inputs.spicetify-nix.legacyPackages.${pkgs.system}.extensions; [
      lastfm
      spicyLyrics
    ];
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable sound
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  hardware.alsa.enablePersistence = true;

  programs.fish = {
  enable = true;
  
  interactiveShellInit = ''
    set fish_greeting # Disable greeting
    fastfetch
  '';

  shellAliases = {
    nixconf = "sudo vim /etc/nixos/configuration.nix";
    nix-switch = "sudo nixos-rebuild switch --flake /etc/nixos/#nixos";
  };
};

  # Define a user account. Don't forget to set a password with ‘passwd’
  users.users.pirkov = {
    isNormalUser = true;
    extraGroups = [ "wheel" 
		    "vboxusers"
		  		];
    shell = pkgs.fish;
  };

  security.sudo.wheelNeedsPassword = false;


  # DE & Display Manager
  services.desktopManager.plasma6.enable = true;
  services.displayManager.plasma-login-manager.enable = true;

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    antigravity-cli
    wget
    git
    fastfetch
    vesktop
    steam
    osu-lazer-bin
    haruna
    obsidian
    kitty
    fish
    alsa-utils
    kid3-kde
    ayugram-desktop
    yt-dlp
    proton-vpn
    nicotine-plus
    qbittorrent
    vscodium
    gruvbox-plus-icons # kde icons
    inputs.helium.packages.${pkgs.system}.default
    inputs.pano-scrobbler-flake.packages.${pkgs.system}.default
  ];

  # This option defines the first version of NixOS you have installed on this particular machine
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  system.stateVersion = "26.05"; # Did you read the comment?
}
