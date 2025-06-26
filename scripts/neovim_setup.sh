#!/bin/bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'
BOLD='\033[1m'

# Banner function
print_banner() {
  clear
  echo -e "${YELLOW}${BOLD}"
  echo "========================================================="
  echo "   🚀  _   _ _   _ ___      ____ ___  ____  _____  🚀   "
  echo "  🦄 | \ | | \ | |_ _|    / ___/ _ \|  _ \| ____| 🦄  "
  echo "  ✨ |  \| |  \| || |    | |  | | | | | | |  _|   ✨  "
  echo "  🔥 | |\  | |\  || |    | |__| |_| | |_| | |___  🔥  "
  echo "  🌈 |_| \_|_| \_|___|    \____\___/|____/|_____| 🌈  "
  echo "========================================================="
  echo "        💻  NVIM-CORE: Neovim ArchLinux Professional Setup  💻"
  echo -e "${NC}"
}

# Print functions
print_header() { echo -e "${BLUE}${BOLD}===> $1${NC}"; }
print_success() { echo -e "${GREEN}${BOLD}[✔] $1${NC}"; }
print_error() {
  echo -e "${RED}${BOLD}[✘] $1${NC}"
  exit 1
}

# Spinner for visual feedback
spinner() {
  local pid=$1
  local delay=0.1
  local spinstr='|/-\'
  while ps -p $pid > /dev/null 2>&1; do
    local temp=${spinstr#?}
    printf " [%c]  " "$spinstr"
    local spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  printf "    \b\b\b\b"
}

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Update system packages
update_system() {
  print_header "Updating system packages..."
  paru || print_error "Failed to update system packages. Is paru installed?"
  print_success "System packages updated."
}

# Install dependencies
install_dependencies() {
  print_header "Installing dependencies via paru..."
  paru --noconfirm -S --needed git curl neovim unzip make lua-language-server stylua fzf nodejs-lts-iron npm clang astyle jdtls python python-pip python-debugpy python-ipython-autoimport python-black python-pipx postgresql postgresql-libs gdb shfmt shellcheck || print_error "Dependency installation failed."
  print_success "All dependencies installed."
}

# Install Vim-Plug (with check)
install_vimplug() {
  print_header "Checking for Vim-Plug..."
  VIM_PLUG_PATH="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"
  if [ -f "$VIM_PLUG_PATH" ]; then
    print_success "Vim-Plug is already installed. Skipping."
    return
  fi
  print_header "Installing Vim-Plug..."
  VIM_PLUG_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload"
  mkdir -p "$VIM_PLUG_DIR"
  curl -fLo "$VIM_PLUG_PATH" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim || print_error "Failed to install Vim-Plug."
  print_success "Vim-Plug installed."
}

# Install LSP servers
install_lsp_servers() {
  print_header "Installing LSP servers..."
  if command_exists npm; then
    sudo npm install -g typescript-language-server vscode-langservers-extracted pyright sql-language-server prettier || print_error "Failed to install LSP servers via npm."
    print_success "LSP servers installed."
  else
    print_error "npm not found. Skipping LSP server installation."
  fi
}

# Install Rust and rust-analyzer
install_rust() {
  print_header "Installing Rust and rust-analyzer..."
  if ! command_exists rustup; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y || print_error "Failed to install rustup."
    source "$HOME/.cargo/env"
  fi
  rustup default stable
  rustup component add rustc rust-analyzer rustfmt
  cargo install exo || print_error "Failed to install exo."
  print_success "Rust, rust-analyzer, and rustfmt installed."
}

# Install Python tools via pipx
install_python_tools() {
  print_header "Installing Python tools via pipx..."
  pipx install debugpy jupytext ipython || print_error "Failed to install Python tools via pipx."
  print_success "Python tools installed."
}

# Setup plugin directory
setup_plugin_dir() {
  print_header "Setting up plugin directory..."
  mkdir -p ~/.local/share/nvim/plugged
  print_success "Plugin directory ready."
}

# Main script
main() {
  print_banner
  echo "Installing dependencies in a virtual environment..."
  echo
  update_system
  install_dependencies
  install_vimplug
  install_lsp_servers
  install_rust
  install_python_tools
  setup_plugin_dir
  echo
  print_success "Installation complete!"
  echo
  echo "${BOLD}Next steps:${NC}"
  echo "1. Copy your Neovim configuration files to ~/.config/nvim/"
  echo "2. Open Neovim and run ':PlugInstall' to install plugins."
  echo "3. Configure PostgreSQL connections in ~/.config/nvim/db_ui/connections.json if needed."
  echo "4. Verify LSP servers with ':LspInstallInfo' and debugging with ':checkhealth'."
}

main "$@"
