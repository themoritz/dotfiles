{ config, pkgs, ... }:

let
  myvim = import ./include/vim.nix { inherit pkgs; };
  latex = pkgs.texlive.combine { inherit (pkgs.texlive)
    scheme-full
    lato
    slantsc
    titlesec
    enumitem
    lastpage
    collection-langgerman
    collection-fontsrecommended
    collection-latexrecommended
    chktex;
  };

in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.device = "/dev/sda";

  networking = {
    hostName = "moritz.local"; # .local to prevent emacs slow load bug
    networkmanager.enable = true;
    networkmanager.insertNameservers = [ "8.8.8.8" "8.8.4.4" ];
  };

  hardware.pulseaudio.enable = true;
  hardware.bluetooth.enable = false;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  fonts.enableDefaultFonts = true;

  environment = {

    systemPackages = with pkgs; [
      arandr
      baobab
      bashInteractive
      bashmount
      calibre
      cloc
      direnv
      dropbox-cli
      dropbox
      emacs
      evince
      firefox
      ghc
      git
      gimp
      gnumake
      google-chrome
      gparted
      udiskie # auto mount
      ntfs3g # read-only filesystem issue
      keepass
      imagemagick
      libreoffice
      stack
      haskellPackages.hlint
      haskellPackages.idris
      latex
      mongodb-tools
      myvim
      gnome3.nautilus
      nixops
      nodejs
      octave
      pavucontrol
      slack
      tree
      vlc
      wget
      # Window manager related:
      feh
      i3status
      i3lock
      dmenu
      networkmanagerapplet
      xdotool
      zip
      unzip
    ];

  };

  programs = {
    fish.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [
      pkgs.samsung-unified-linux-driver
      # pkgs.splix # For Samsung printers (ML-1640, but not ML-2165)
    ];
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us,de";
    xkbOptions = "grp:alt_shift_toggle";
    windowManager.i3 = {
      enable = true;
    };
    synaptics = {
      enable = true;
      accelFactor = "0.001";
      minSpeed = "1.0";
      maxSpeed = "3.0";
      buttonsMap = [ 1 3 2 ];
      palmDetect = true;
      palmMinWidth = 5;
      palmMinZ = 20;
      vertTwoFingerScroll = true;
    };
  };

  services.mongodb = {
    enable = true;
  };

  services.trezord.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.moritz = {
    isNormalUser = true;
    description = "Moritz Drexl";
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "moritz";
    uid = 1000;
    shell = "${pkgs.fish}/bin/fish";
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";

  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/etc/nixos/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

}
