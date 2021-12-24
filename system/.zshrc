
#### FIG ENV VARIABLES ####
[ -s ~/.fig/shell/pre.sh ] && source ~/.fig/shell/pre.sh]
#### END FIG ENV VARIABLES ####

DOTFILES_DIR="$HOME/.dotfiles"

# source all dotfiles from ~/.dotfiles/dotfiles
for DOTFILE in "$DOTFILES_DIR"/system/.{env,alias,functions,path}; do
  [ -f "$DOTFILE" ] && . "$DOTFILE"
done

# for direnv, so that .envrc files can set up local environment properly
eval "$(direnv hook zsh)"

# starship
eval "$(starship init zsh)"

#### FIG ENV VARIABLES ####
# Please make sure this block is at the end of this file.
[ -s ~/.fig/fig.sh ] && source ~/.fig/fig.sh
#### END FIG ENV VARIABLES ####
