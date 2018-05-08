{ pkgs ? import <nixpkgs> {} }:

let
  emacsWithPackages = (pkgs.emacsPackagesNgGen pkgs.emacs).emacsWithPackages;

in
  emacsWithPackages (epkgs: (with epkgs.melpaStablePackages; [
    magit
    monokai-theme
    evil
    evil-magit
    ivy
    projectile
    counsel
    counsel-projectile
    swiper
    powerline
  ]) ++ (with epkgs.melpaPackages; [
    haskell-mode
    dhall-mode
    dante
    nix-mode
  ]) ++ (with epkgs.elpaPackages; [
    undo-tree      # ; <C-x u> to show the undo tree
    auctex         # ; LaTeX mode
    beacon         # ; highlight my cursor when scrolling
  ]))
