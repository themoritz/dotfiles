# Generate with:
# antibody bundle < ~/.zsh/plugins.txt > ~/.zsh/plugins.sh
source ~/.zsh/plugins.sh

# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix

# For quick iteration:
# source <(antibody init)
# antibody bundle < ~/.zsh/plugins.txt

eval "$(/opt/homebrew/bin/brew shellenv)"
# eval "$(/usr/local/bin/brew shellenv)"
alias ibrew='arch -x86_64 /usr/local/bin/brew'

FZF_DEFAULT_OPTS='--color light'

## Completion
autoload -Uz compinit
compinit

# Enable menu selection for interactive completion lists
zstyle ':completion:*' menu select

# Enable colored completions matching LS_COLORS (for ls-like coloring)
zstyle ':completion:*:default' list-colors "${(s.:.)LS_COLORS}"

## History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_all_dups
setopt hist_find_no_dups
setopt hist_save_no_dups
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

export FZF_CTRL_R_OPTS='--bind="ctrl-k:execute-silent(hist d `echo {} | awk '"'"'{print $1}'"'"'`)"'

# fzf key bindings and completions
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# With Nix:
# source $(fzf-share)/key-bindings.zsh
# source $(fzf-share)/completion.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export NODE_VERSIONS="$NVM_DIR/versions/node"

eval "$(direnv hook zsh)"
eval "$(starship init zsh)"
source "$HOME/.cargo/env"

[ -f "/Users/moritz/.ghcup/env" ] && . "/Users/moritz/.ghcup/env" # ghcup-env

export PATH=$PATH:$(go env GOPATH)/bin

export PATH="/Users/moritz/.local/bin:$PATH"
export PATH="/Users/moritz/.local/bin/zig:$PATH"

alias vim="nvim"
alias lg="lazygit"
alias pip="uv pip"


printf '\33c\e[3J'

