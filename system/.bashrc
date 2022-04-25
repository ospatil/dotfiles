# Fig pre block. Keep at the top of this file.
. "$HOME/.fig/shell/bashrc.pre.bash"

DOTFILES_DIR="$HOME/.dotfiles"

# source all dotfiles from ~/.dotfiles/system
for DOTFILE in "$DOTFILES_DIR"/system/.{env,alias,functions,path}; do
  [ -f "$DOTFILE" ] && . "$DOTFILE"
done

# For homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# For pyenv
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# for direnv, so that .envrc files can set up local environment properly
eval "$(direnv hook bash)"

# starship
eval "$(starship init bash)"

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# Fig post block. Keep at the bottom of this file.
. "$HOME/.fig/shell/bashrc.post.bash"
