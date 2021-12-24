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
  git clone https://github.com/ospatil/dotfiles.git "WORK_DIR"/dotfiles
  # Copy the dotfiles folder to ~/.dotfiles
  cp -R "$WORK_DIR"/dotfiles/system "$DOTFILES_HOME"/system
  cp -R "$WORK_DIR"/dotfiles/config "$DOTFILES_HOME"/config
}

function install_brew_packages {
  echi "Installing brew packages"
  # Install packages, casks and apps
  brew bundle --file="$WORK_DIR"/dotfiles/install/
}

function install_node {
  echo "Installing Node and global packages"
  # Install volta
  bash -c "$(curl -fsSL https://get.volta.sh)"
  # Install node
  volta install node
  # # Install global packages
  while IFS= read -r line; do
    npm i -g "$line"
  done < "$WORK_DIR"/dotfiles/install/npmfile
}

function install_arkade_tools {
  echo "Installing Arkade and k8s tools"
  bash -c "$(curl -fsSL https://get.arkade.dev)"
  # Install tools
  while IFS= read -r line; do
    ark get "$line"
  done < "$WORK_DIR"/dotfiles/install/arkadefile
  # Install vagrant vbguest extensions
  vagrant plugin install vagrant-vbguest
}

function install_vscode_extensions {
  echo "Installing VS Code extensions"
  # Install base VS Code plugins
  while IFS= read -r line; do
    code --install-extension "$line" --force
  done < "$WORK_DIR"/dotfiles/install/vscodefile
}

# Manual steps - install finda - https://keminglabs.com/finda/
function linkup {
  echo "Creating links"
  # Create links for dotfiles and config files
  ln -sv "$DOTFILES_HOME/system/.zshrc" ~
  ln -sv "$DOTFILES_HOME/system/.inputrc" ~
  ln -sv "$DOTFILES_HOME/config/git/.gitconfig" ~
  ln -sv "$DOTFILES_HOME/config/git/.gitignore_global" ~
  # Create a directory for starship config
  mkdir -p "$HOME"/.config
  ln -sv "$DOTFILES_HOME/config/starship/starship.toml" ~/.config
}

# Run the setup
install_homebrew
install_git
copy_dotfiles
install_brew_packages
install_node
install_arkade_tools
install_vscode_extensions
linkup
