#!/bin/sh

UPSTREAM="https://github.com/gbraad-dotfiles/upstream"
STABLE="https://github.com/gbraad/dotfiles-stable"
TARGET="${HOME}/.dotfiles"


is_root() {
  [ "$(id -u)" = "0" ]
}

check_permissions() {
  # First check if user is root
  if is_root; then
    return 0  # Root user always has full permissions
  fi
  
  # For non-root users, check sudo capabilities
  if ! sudo -n true 2>/dev/null; then
    return 1
  fi
  return 0
}

# Get command prefix (empty for root, sudo for others with sudo rights)
get_cmd_prefix() {
  if is_root; then
    echo ""
  else
    echo "sudo "
  fi
}

install_requirements() {
  APTPKGS="git"
  RPMPKGS="git-core"

  # Get the appropriate command prefix
  CMD_PREFIX=$(get_cmd_prefix)

  # Crude multi-os installation option
  if [ -x "/usr/bin/apt-get" ]
  then
    ${CMD_PREFIX}apt-get install -y ${APTPKGS}
  elif [ -x "/usr/bin/dnf" ]
  then
    ${CMD_PREFIX}dnf install -y ${RPMPKGS}
  fi
}

check_git_installed() {
  if ! command -v git &> /dev/null; then
    return 1
  fi
  return 0
}

clone_repository() {
  git clone ${STABLE} ${TARGET} --depth 2
}

install_dotfiles() {
  # bash is required to bootstrap
  bash ${TARGET}/install.sh
}

if ! check_git_installed; then
  if check_permissions; then
    install_requirements
  else
    echo "Git is not installed and you do not have the permissions to install"
    exit 1
  fi
fi

clone_repository
install_dotfiles
