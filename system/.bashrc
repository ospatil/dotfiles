DOTFILES_DIR="$HOME/.dotfiles"

# source all dotfiles from ~/.dotfiles/system
for DOTFILE in "$DOTFILES_DIR"/system/.{env,alias,functions,path}; do
  [ -f "$DOTFILE" ] && . "$DOTFILE"
done

# For homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# for direnv, so that .envrc files can set up local environment properly
eval "$(direnv hook bash)"

# starship
eval "$(starship init bash)"

# for node version management tool fnm
eval "$(fnm env --use-on-cd)"

# for fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# for inshellisense
[ -f ~/.inshellisense/bash/init.sh ] && source ~/.inshellisense/bash/init.sh
