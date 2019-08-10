{ pkgs ? import <nixpkgs> {} }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  emacs = if isDarwin then pkgs.emacsMacport else pkgs.emacs;
  emacsWithPackages = (pkgs.emacsPackagesNgGen emacs).emacsWithPackages;

in
  emacsWithPackages (epkgs: (with epkgs.melpaStablePackages; [
    avy
    magit
    ivy
    counsel
    swiper
    direnv
    markdown-mode
    yaml-mode
    company
    flycheck
    which-key
    wgrep
  ]) ++ (with epkgs.melpaPackages; [
    haskell-mode
    dhall-mode
    dante
    nix-mode
    diminish
    expand-region
    leuven-theme
    powerline
    yasnippet
    default-text-scale
    # Rust
    rust-mode
    flycheck-rust
    racer
    cargo
  ] ++
  (if isDarwin
  then [exec-path-from-shell]
  else [])) ++ (with epkgs.elpaPackages; [
    undo-tree
    auctex
  ]))
