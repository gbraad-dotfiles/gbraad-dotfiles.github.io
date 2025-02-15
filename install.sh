#!/bin/sh

check_git_installed() {
  if ! command -v git &> /dev/null; then
    echo "Error: Git is not installed. Please install Git and try again."
    exit 1
  fi
}

clone_repository() {
  git clone https://github.com/gbraad-dotfiles/upstream ~/.dotfiles --recursive
}

install_dotfiles() {
  sh ~/.dotfiles/install.sh
}

check_git_installed
clone_repository
install_dotfiles
