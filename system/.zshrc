DOTFILES_DIR="$HOME/.dotfiles"

# source all dotfiles from ~/.dotfiles/dotfiles
for DOTFILE in "$DOTFILES_DIR"/system/.{env,alias,functions,path}; do
  [ -f "$DOTFILE" ] && . "$DOTFILE"
done

# For homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# for direnv, so that .envrc files can set up local environment properly
eval "$(direnv hook zsh)"

# starship
eval "$(starship init zsh)"

# Use emacs mode
bindkey -e

# zsh-syntax-highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# for fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# for inshellisense
[[ -f ~/.inshellisense/zsh/init.zsh ]] && source ~/.inshellisense/zsh/init.zsh
