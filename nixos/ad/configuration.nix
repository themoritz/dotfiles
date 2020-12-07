# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.device = "/dev/nvme0n1";

  # Define your hostname.
  networking.hostName = "andreas.local"; # .local to prevent emacs load bug
  networking.networkmanager.insertNameservers = [ "8.8.8.8" "8.8.4.4" ];

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "de";
    defaultLocale = "de_DE.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  fonts.enableDefaultFonts = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    emacs
    evince
    firefox
    google-chrome
    ghostscript # Provides ps2pdf and pdf2ps
    gimp
    gnome3.gnome_terminal
    gnome3.nautilus
    gv
    gqview
    k3b
    texlive.combined.scheme-full # Provides xdvi
    libreoffice
    mpage
    tree
    vim
    zip
    unzip
  ];

  environment.gnome3.excludePackages = pkgs.gnome3.optionalPackages;

  programs.zsh.enable = true;

  # List services that you want to enable:

  # Enable CUPS to print documents. Actual printer has to be added manually.
  services.printing = {
    enable = true;
    drivers = [ pkgs.samsung-unified-linux-driver ];
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    # For some reason, layout does not have any effect with
    # Gnome. Go to input settings and configure there.
    layout = "de";
    desktopManager.gnome3.enable = true;
    displayManager.lightdm = {
      enable = true;
      autoLogin.enable = true;
      autoLogin.user = "ad";
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.ad = {
    isNormalUser = true;
    description = "Andreas Drexl";
    extraGroups = [ "wheel" ]; # Sudo user
    uid = 1000;
    shell = "${pkgs.zsh}/bin/zsh";
    initialPassword = "ad";
  };

  nixpkgs.config.allowUnfree = true;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";

}
