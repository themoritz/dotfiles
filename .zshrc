# Generate with:
# antibody bundle < ~/.zsh/plugins.txt > ~/.zsh/plugins.sh
source ~/.zsh/plugins.sh

# For quick iteration:
# source <(antibody init)
# antibody bundle < ~/.zsh/plugins.txt

eval "$(/opt/homebrew/bin/brew shellenv)"

FZF_DEFAULT_OPTS='--color light'

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

eval "$(direnv hook zsh)"
eval "$(starship init zsh)"
