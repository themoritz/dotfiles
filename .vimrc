" Pathogen Plugin Manager
" ~~~~~~~~~~~~~~~~~~~~~~~
call pathogen#infect()

" General Settings
" ~~~~~~~~~~~~~~~~
filetype plugin indent on             " load filetype plugins/indent settings
syntax on                             " syntax highlighting on

set nocompatible                      " explicitly get out of vi-compatible mode
set noexrc                            " don't use local version of .(g)vimrc, .exrc
set hidden                            " you can change buffers without saving
set encoding=utf-8
set laststatus=2                      " alsways show a status line

set lazyredraw                        " do not redraw while running macros

set backspace=indent,eol,start        " make backspace a more flexible

set backup                            " make backup files
set backupdir=~/.backup/vim           " where to put backup files

set clipboard+=unnamed                " share windows clipboard
set directory=~/.backup/vim           " directory to place swap files in
set fileformats=unix,dos,mac          " support all three, in this order
set iskeyword+=_,$,@,%,#,:            " none of these are word dividers
set mouse=a                           " use mouse everywhere
set noerrorbells                      " don't make noise

set wildmenu                          " turn on command line completion wild style
set wildmode=list:longest             " turn on wild mode huge list
set wildignore=*.dll,*.o,*.obj,*.bak,*.exe,*.pyc,*.jpg,*.gif,*.png,*.pdf,*.aux,*.gz,*.nav,*.log,*.out,*.snm,*.toc,*.bbl,*.blg

set nohlsearch                        " do not highlight searched for phrases
set incsearch                         " BUT do highlight as you type you search phrase

set list                              " we do what to show tabs and trailing white space
set listchars=tab:>-,trail:~

set nostartofline                     " leave my cursor where it was
set novisualbell                      " don't blink
set shortmess=aOstT                   " shortens messages to avoid 'press a key' prompt

set showcmd                           " show the command being typed
set showmatch                         " show matching brackets

set expandtab                         " no real tabs please!
set formatoptions=rq                  " Automatically insert comment leader on return, and let gq format comments
set ignorecase                        " case insensitive by default
set infercase                         " case inferred by default
set nowrap                            " do not wrap line
set shiftround                        " when at 3 spaces, and I hit > ... go to 4, not 5
set smartcase                         " if there are caps, go case-sensitive
set shiftwidth=2                      " auto-indent amount when using cindent, >>, << and stuff like that
set softtabstop=2                     " when hitting tab or backspace, how many spaces should a tab be (see expandtab)
set tabstop=2                         " real tabs should be 8, and they will show with set list on

set nofoldenable                      " no folding


" Appearance
" ~~~~~~~~~~
set t_Co=256
set background=dark
colorscheme mustang


" Workarounds
" ~~~~~~~~~~~

" Avoids :call histdel (used to be 3)
set cmdheight=1

" Avoids waiting after <Esc>
set ttimeoutlen=0

set grepprg=grep\ -nH\ $*


" Own Functions and Mappings
" ~~~~~~~~~~~~~~~~~~~~~~~~~~

" General
nmap <Down> :bn<Cr>
nmap <Up> :bp<Cr>

" Paragraph wrap
nmap <Leader>w vipgq

" Go to directory of the first file that is opened (if any)
if expand('%') != ''
  cd %:h
endif
