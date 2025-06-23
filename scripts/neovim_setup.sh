#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'
BOLD='\033[1m'

# Spinner for visual feedback
spinner() {
  local pid=$1
  local delay=0.1
  local spinstr='|/-\'
  while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
    local temp=${spinstr#?}
    printf " [%c]  " "$spinstr"
    local spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  printf "    \b\b\b\b"
}

# Print functions
print_header() { echo -e "${BLUE}${BOLD}===> $1${NC}"; }
print_success() { echo -e "${GREEN}${BOLD}[✔] $1${NC}"; }
print_error() {
  echo -e "${RED}${BOLD}[✘] $1${NC}"
  exit 1
}

# Banner
clear
echo -e "${YELLOW}${BOLD}"
echo "========================================="
echo "   Neovim dependencies for Arch Linux    "
echo "========================================="
echo -e "${NC}"
echo "Installing dependencies in a virtual environment..."
echo

echo "Starting Neovim dependency installation for Arch Linux..."

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Update system packages
echo "Updating system packages..."
paru

# Install basic tools
echo "Installing all the dependencies needed thorough package manager"
paru --noconfirm -S --needed git curl neovim unzip make lua-language-server stylua fzf nodejs-lts-iron npm clang astyle jdtls python python-pip python-debugpy python-ipython-autoimport python-black python-pipx postgresql postgresql-libs gdb shfmt shellcheck

# Install Vim-Plug
echo "Installing Vim-Plug..."
VIM_PLUG_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload"
mkdir -p "$VIM_PLUG_DIR"
curl -fLo "$VIM_PLUG_DIR/plug.vim" --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install LSP servers
echo "Installing LSP servers..."
if command_exists npm; then
  sudo npm install -g typescript-language-server vscode-langservers-extracted pyright sql-language-server prettier
else
  echo "Error: npm not found. Skipping LSP server installation."
  exit 1
fi

# Install Rust and rust-analyzer
echo "Installing Rust and rust-analyzer..."
if ! command_exists rustup; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
fi

# Installing rust, rust-analyzer, rustfmt
echo "Installing rust, rust-analyzer and rustfmt"
rustup default stable
rustup component add rustc rust-analyzer rustfmt
cargo install exo

echo "Installing dependencies through pipx"
pipx install debugpy jupytext ipython

# Clone plugins (handled by Vim-Plug, but ensure directory exists)
echo "Setting up plugin directory..."
mkdir -p ~/.local/share/nvim/plugged

# Instructions for user
echo "Installation complete!"
echo "Next steps:"
echo "1. Copy your Neovim configuration files to ~/.config/nvim/"
echo "2. Open Neovim and run ':PlugInstall' to install plugins."
echo "3. Configure PostgreSQL connections in ~/.config/nvim/db_ui/connections.json if needed."
echo "4. Verify LSP servers with ':LspInstallInfo' and debugging with ':checkhealth'."
