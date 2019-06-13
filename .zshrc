# Generate with:
# antibody bundle < ~/.zsh/plugins.txt > ~/.zsh/plugins.sh
source ~/.zsh/plugins.sh

# For quick iteration:
# source <(antibody init)
# antibody bundle < ~/.zsh/plugins.txt

export FZF_DEFAULT_OPTS='--color light'

source $(fzf-share)/key-bindings.zsh
source $(fzf-share)/completion.zsh

eval "$(direnv hook zsh)"
