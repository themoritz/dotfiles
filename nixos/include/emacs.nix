{ pkgs ? import <nixpkgs> {} }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  emacs = if isDarwin then pkgs.emacsMacport else pkgs.emacs;
  emacsWithPackages = (pkgs.emacsPackagesNgGen emacs).emacsWithPackages;

in
  emacsWithPackages (epkgs: (with epkgs.melpaStablePackages; [
    ace-window
    avy
    magit
    monokai-theme
    evil
    ivy
    ivy-hydra
    hydra
    counsel
    swiper
    powerline
    nix-buffer
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
    evil-magit
  ] ++
  (if isDarwin
  then [exec-path-from-shell]
  else [])) ++ (with epkgs.elpaPackages; [
    undo-tree
    auctex
  ]))
