#!/bin/sh

install_requirements() {
  APTPKGS="git"
  RPMPKGS="git-core"

  # Crude multi-os installation option
  if [ -x "/usr/bin/apt-get" ]
  then
    sudo apt-get install -y $APTPKGS
  elif [ -x "/usr/bin/dnf" ]
  then
    sudo dnf install -y $RPMPKGS
  fi
}

check_git_installed() {
  if ! command -v git &> /dev/null; then
    return 1
  fi
  return 0
}

clone_repository() {
  git clone https://github.com/gbraad-dotfiles/upstream ~/.dotfiles --depth 2
}

install_dotfiles() {
  # bash is required to bootstrap
  bash ~/.dotfiles/install.sh
}

check_sudo_permissions() {
  echo "Checking if the current user has sudo permissions..."
  if ! sudo -n true 2>/dev/null; then
    return 1
  fi
  return 0
}

if ! check_git_installed; then
  if check_sudo_permissions; then
    install_requirements
  else
    "Git is not installed and you do not have the permissions to install"
    exit 1
  fi
fi

clone_repository
install_dotfiles
