{ config, pkgs, ... }:

let
  myvim = import ./include/vim.nix { inherit pkgs; };
  latex = pkgs.texlive.combine { inherit (pkgs.texlive)
    scheme-basic
    lato
    slantsc
    collection-fontsrecommended
    collection-latexrecommended;
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

  networking.hostName = "moritz.local"; # .local to prevent emacs slow load bug
  networking.networkmanager.enable = true;
  networking.networkmanager.insertNameservers = [ "8.8.8.8" "8.8.4.4" ];

  hardware.pulseaudio.enable = true;

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

    # List packages installed in system profile. To search by name, run:
    systemPackages = with pkgs; [
      skype
      emacs
      gnumake
      haskellPackages.stack
      mongodb-tools
      latex
      wget
      tree
      nodejs
      myvim
      google-chrome
      bashInteractive
      networkmanagerapplet
      dropbox-cli
      dropbox
      git
      # Window manager related:
      feh
      i3status
      i3lock
      dmenu
    ];

  };

  programs = {
    zsh.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [
      pkgs.splix # For Samsung printers (ML-1640)
      # (import ./include/brother.nix { pkgs = pkgs; })
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.moritz = {
    isNormalUser = true;
    description = "Moritz Drexl";
    extraGroups = [ "wheel" "networkmanager" ];
    uid = 1000;
    shell = "${pkgs.zsh}/bin/zsh";
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.09";

  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixpkgs"
    "nixos-config=/etc/nixos/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

}
