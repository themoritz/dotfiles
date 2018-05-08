{ pkgs ? import <nixpkgs> {} }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  emacs = if isDarwin then pkgs.emacs-mac else pkgs.emacs;
  emacsWithPackages = (pkgs.emacsPackagesNgGen emacs).emacsWithPackages;

in
  emacsWithPackages (epkgs: (with epkgs.melpaStablePackages; [
    avy
    magit
    monokai-theme
    evil
    evil-magit
    ivy
    ivy-hydra
    hydra
    counsel
    swiper
    powerline
    markdown-mode
    yaml-mode
    company
    flycheck
    fill-column-indicator
  ]) ++ (with epkgs.melpaPackages; [
    haskell-mode
    dhall-mode
    dante
    nix-mode
  ] ++
  (if isDarwin
  then [exec-path-from-shell]
  else [])) ++ (with epkgs.elpaPackages; [
    undo-tree
    auctex
  ]))
