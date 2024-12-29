#!/usr/bin/env bash

set -e # fail the entire script if any command fails

# Create directory where the dotfiles repo will be cloned
WORK_DIR="$HOME"/work/github
mkdir -p "$WORK_DIR"
# Create local directory for dotfiles ~/.dotfiles
DOTFILES_HOME="$HOME"/.dotfiles
mkdir -p "$DOTFILES_HOME"

function install_homebrew {
  # Install brew
  echo "Installing Homebrew"
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # add brew to the path
  eval "$(/opt/homebrew/bin/brew shellenv)"
}

function install_git {
  # Install git
  echo "Installing Git"
  brew install git
}

function copy_dotfiles {
  # Clone this repo
  echo "Cloning the dotfiles repo and copying the dotfiles to ~/.dotfiles"
  git clone https://github.com/ospatil/dotfiles.git "$WORK_DIR"/dotfiles
  # Copy the dotfiles folder to ~/.dotfiles
  cp -R "$WORK_DIR"/dotfiles/system "$DOTFILES_HOME"/system
  cp -R "$WORK_DIR"/dotfiles/config "$DOTFILES_HOME"/config
}

function install_brew_packages {
  echo "Installing brew packages"
  # Install packages, casks and apps
  brew bundle --file="$WORK_DIR"/dotfiles/install/Brewfile
}

function install_node {
  echo "Installing Node and global packages"
  # Install node
  fnm install --lts
  # # Install global packages
  while IFS= read -r line; do
    npm i -g "$line"
  done < "$WORK_DIR"/dotfiles/install/npmfile
}

# function install_vscode_extensions {
#   echo "Installing VS Code extensions"
#   # Install base VS Code plugins
#   while IFS= read -r line; do
#     code --install-extension "$line" --force
#   done < "$WORK_DIR"/dotfiles/install/vscodefile
# }

function install_misc {
  echo "Installing other utilities"
  curl -s https://cht.sh/:cht.sh | sudo tee /usr/local/bin/cht.sh && sudo chmod +x /usr/local/bin/cht.sh
}

function linkup {
  echo "Creating links"
  # Create links for dotfiles and config files
  ln -sfv "$DOTFILES_HOME/system/.zshrc" ~
  ln -sfv "$DOTFILES_HOME/system/.bashrc" ~
  ln -sfv "$DOTFILES_HOME/system/.bash_profile" ~
  ln -sfv "$DOTFILES_HOME/system/.inputrc" ~
  ln -sfv "$DOTFILES_HOME/config/git/.gitconfig" ~
  ln -sfv "$DOTFILES_HOME/config/git/.gitignore_global" ~
  # Create a directory for starship config
  mkdir -p "$HOME"/.config
  ln -sfv "$DOTFILES_HOME/config/starship/starship.toml" ~/.config
  # Create a directory for vim config
  mkdir -p "$HOME"/.config/nvim
  ln -sfv "$DOTFILES_HOME/config/nvim/init.vim" ~/.config/nvim
  # Create a directory for ghostty config
  mkdir -p "$HOME"/.config/ghostty
  ln -sfv "$DOTFILES_HOME/config/ghostty/config" ~/.config/ghostty

  # create a directory for pdftools
  mkdir -p "$HOME"/.config/stirling-pdf/trainingData "$HOME"/.config/stirling-pdf/extraConfigs "$HOME"/.config/stirling-pdf/logs
}

function setup_nvim {
  echo "Setting up nvim"
  # Download Plug plugin manager
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  nvim +PlugInstall +UpdateRemotePlugins +qall
}

# Run the setup
install_homebrew
install_git
copy_dotfiles
install_brew_packages
install_node
# install_vscode_extensions
install_misc
linkup
setup_nvim

# Manual steps
# install finda - https://keminglabs.com/finda/
# pip3 install bpython
# Install snazzy terminal theme - https://github.com/sindresorhus/terminal-snazzy and change font to jetbrains-mono-nerd-font 14 size
# Find the brew installed bash: 'which -a bash', add the path to '/etc/shells' and set the shell 'chpass -s <PATH>'.
