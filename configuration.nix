# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual ().

{ config, lib, pkgs, inputs, ... }:

{
  imports = [ 
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree software
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.hostName = "nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Almaty";

  # nvidia drivers
  hardware.graphics.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    # legacy branch
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
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
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user
    shell = pkgs.fish;
  };


  # DE & Display Manager
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    fastfetch
    spotify
    discord
    haruna
    obsidian
    kitty
    fish
    alsa-utils
    telegram-desktop
    proton-vpn
    inputs.helium.packages.${pkgs.system}.default
    inputs.pano-scrobbler-flake.packages.${pkgs.system}.default
  ];

  # This option defines the first version of NixOS you have installed on this particular machine
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  system.stateVersion = "26.05"; # Did you read the comment?
}
