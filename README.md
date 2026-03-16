# dotfiles

Dotfiles for macOS — reproducible setup for a new Mac from scratch.

## What's included

- **Shell config** — bash/zsh with aliases, functions, PATH, starship prompt
- **Brew packages** — formulae, casks, and VS Code extensions via Brewfile
- **Language runtimes** — Node (LTS), Python, Go managed by [mise](https://mise.jdx.dev/)
- **npm globals** — utility packages (http-server, npkill, degit, etc.)
- **Git config** — aliases, diff/merge with VS Code, credential helper
- **App configs** — Ghostty terminal, iTerm2 preferences, Starship prompt
- **macOS defaults** — Finder, Dock, screenshots, and other system preferences
- **iTerm2 broadcast functions** — send commands to all/other tabs (`baws`, `bcd`, `broadcast`, `broadcast-all`)

## Installation

On a fresh Mac:

```bash
# Install Xcode command line tools (includes git)
xcode-select --install

# Clone and run
git clone https://github.com/ospatil/dotfiles.git ~/work/github/dotfiles
cd ~/work/github/dotfiles
./setup.sh
```

## Keeping in sync

Run `backup.sh` periodically to capture the current state of installed packages back into the repo:

```bash
./backup.sh
# Review and commit the changes
git diff
git add -A && git commit -m "backup: update installed packages"
```

## Structure

```
├── setup.sh                 # Main setup script
├── backup.sh                # Dump current packages back to repo
├── macos-defaults.sh        # macOS system preferences
├── system/
│   ├── .alias               # Shell aliases
│   ├── .bashrc              # Bash config
│   ├── .bash_profile        # Bash profile
│   ├── .env                 # Environment variables
│   ├── .functions           # Shell functions (incl. iTerm2 broadcast)
│   ├── .inputrc             # Readline config
│   ├── .path                # PATH setup
│   └── .zshrc               # Zsh config
├── config/
│   ├── ghostty/config       # Ghostty terminal config
│   ├── git/.gitconfig       # Git config
│   ├── git/.gitignore_global
│   ├── iterm2/              # iTerm2 preferences plist
│   └── starship/starship.toml
└── install/
    ├── Brewfile             # Homebrew packages, casks, VS Code extensions
    └── npmfile              # Global npm packages
```

## Post-install manual steps

- Install [snazzy terminal theme](https://github.com/sindresorhus/terminal-snazzy) and set font to JetBrains Mono Nerd Font, size 14
