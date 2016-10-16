{ pkgs }:

with pkgs;

vim_configurable.customize {
  name = "vim";
  vimrcConfig = {
    customRC = ''
      filetype plugin indent on
      syntax on
      set nocompatible
      set backspace=indent,eol,start
      colorscheme molokai
      nmap <Down> :bn<Cr>
      nmap <Up> :bp<Cr>
    '';
    vam.knownPlugins = vimPlugins;
    vam.pluginDictionaries = [
      {
        names = [
          "vim-addon-nix"
          "molokai"
        ];
      }
    ];
  };
}
