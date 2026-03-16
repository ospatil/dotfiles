#!/usr/bin/env bash

set -e # fail the entire script if any command fails

# Create directory where the dotfiles repo will be cloned
WORK_DIR="$HOME"/work/github
mkdir -p "$WORK_DIR"
# Create local directory for dotfiles ~/.dotfiles
DOTFILES_HOME="$HOME"/.dotfiles
mkdir -p "$DOTFILES_HOME"

function install_homebrew {
  echo "Installing Homebrew"
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
}

function install_git {
  echo "Installing Git"
  brew install git
}

function copy_dotfiles {
  echo "Cloning the dotfiles repo and copying the dotfiles to ~/.dotfiles"
  git clone https://github.com/ospatil/dotfiles.git "$WORK_DIR"/dotfiles
  cp -R "$WORK_DIR"/dotfiles/system "$DOTFILES_HOME"/system
  cp -R "$WORK_DIR"/dotfiles/config "$DOTFILES_HOME"/config
}

function install_brew_packages {
  echo "Installing brew packages"
  brew bundle --file="$WORK_DIR"/dotfiles/install/Brewfile
}

function install_mise {
  echo "Installing mise and setting up language runtimes"
  eval "$(mise activate bash)"
  mise use --global node@lts
  mise use --global python@latest
  mise use --global go@latest
}

function install_node_packages {
  echo "Installing global npm packages"
  while IFS= read -r line; do
    npm i -g "$line"
  done < "$WORK_DIR"/dotfiles/install/npmfile
}

function install_misc {
  echo "Installing other utilities"
  curl -s https://cht.sh/:cht.sh | sudo tee /usr/local/bin/cht.sh && sudo chmod +x /usr/local/bin/cht.sh
}

function setup_configs {
  echo "Setting up application configs"
  # iTerm2 - point to load prefs from dotfiles
  cp "$WORK_DIR"/dotfiles/config/iterm2/com.googlecode.iterm2.plist "$DOTFILES_HOME"/config/iterm2/
  defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$DOTFILES_HOME/config/iterm2"
  defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
}

function linkup {
  echo "Creating links"
  ln -sfv "$DOTFILES_HOME/system/.zshrc" ~
  ln -sfv "$DOTFILES_HOME/system/.bashrc" ~
  ln -sfv "$DOTFILES_HOME/system/.bash_profile" ~
  ln -sfv "$DOTFILES_HOME/system/.inputrc" ~
  ln -sfv "$DOTFILES_HOME/config/git/.gitconfig" ~
  ln -sfv "$DOTFILES_HOME/config/git/.gitignore_global" ~
  mkdir -p "$HOME"/.config
  ln -sfv "$DOTFILES_HOME/config/starship/starship.toml" ~/.config
  mkdir -p "$HOME"/.config/ghostty
  ln -sfv "$DOTFILES_HOME/config/ghostty/config" ~/.config/ghostty
}

function set_default_shell {
  echo "Setting Homebrew bash as default shell"
  BREW_BASH="/opt/homebrew/bin/bash"
  if ! grep -q "$BREW_BASH" /etc/shells; then
    echo "$BREW_BASH" | sudo tee -a /etc/shells
  fi
  chsh -s "$BREW_BASH"
}

function apply_macos_defaults {
  echo "Applying macOS defaults"
  bash "$WORK_DIR"/dotfiles/macos-defaults.sh
}

# Run the setup
install_homebrew
install_git
copy_dotfiles
install_brew_packages
install_mise
install_node_packages
install_misc
setup_configs
linkup
set_default_shell
apply_macos_defaults

# Manual steps
# Install snazzy terminal theme - https://github.com/sindresorhus/terminal-snazzy and change font to jetbrains-mono-nerd-font 14 size
