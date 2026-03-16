DOTFILES_DIR="$HOME/.dotfiles"

# source all dotfiles from ~/.dotfiles/system
for DOTFILE in "$DOTFILES_DIR"/system/.{env,alias,functions,path}; do
  [ -f "$DOTFILE" ] && . "$DOTFILE"
done

# For homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# mise version manager
eval "$(mise activate bash)"

# for direnv, so that .envrc files can set up local environment properly
# eval "$(direnv hook bash)"

# starship
eval "$(starship init bash)"

if [[ "$TERM_PROGRAM" == "ghostty" ]]; then
    export TERM=xterm-256color
fi

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# for linkerd cli for k8s service mesh
export PATH=$HOME/.linkerd2/bin:$PATH
