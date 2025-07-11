#!/usr/bin/env bash
set -e

REPO_URL="https://github.com/rishabh181104/nvim"
CONFIG_DIR="$HOME/.config/nvim"
BACKUP_DIR="$HOME/.config/nvim.backup.$(date +%s)"

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Install git and neovim if missing
install_deps() {
  for dep in git nvim; do
    if ! command_exists $dep; then
      echo "$dep not found. Attempting to install..."
      if command_exists pacman; then
        sudo pacman -Sy --noconfirm $dep
      elif command_exists apt; then
        sudo apt update && sudo apt install -y $dep
      elif command_exists dnf; then
        sudo dnf install -y $dep
      elif command_exists brew; then
        brew install $dep
      else
        echo "Please install $dep manually. Unsupported package manager." >&2
        exit 1
      fi
    fi
  done
}

# Backup existing config if present
backup_config() {
  if [ -d "$CONFIG_DIR" ]; then
    echo "Backing up existing nvim config to $BACKUP_DIR"
    mv "$CONFIG_DIR" "$BACKUP_DIR"
  fi
}

# Clone the config
clone_config() {
  echo "Cloning config from $REPO_URL to $CONFIG_DIR"
  git clone --depth=1 "$REPO_URL" "$CONFIG_DIR"
}

# Sync plugins with lazy.nvim
sync_plugins() {
  echo "Syncing plugins with lazy.nvim (this may take a moment)"
  nvim --headless "+Lazy! sync" +qa
}

main() {
  install_deps
  backup_config
  clone_config
  sync_plugins
  echo "\n✅ Neovim config installed! Launch nvim and enjoy."
}

main "$@"
