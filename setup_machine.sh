#!/bin/bash
# Sets up a machine with these dotfiles. Safe to re-run: a second run changes nothing in your
# rc files and just updates the installed tools to their latest versions.
#
# - Shared configs are symlinked into $HOME (an existing regular file is backed up first).
# - ~/.bashrc / ~/.zshrc are never replaced (they hold machine-specific stuff like API keys);
#   we only append a single `source` line if it isn't already there.
#
# Set SKIP_INSTALL=1 to only link files and wire up rc files (no package installs).
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Append a line to a file unless a line matching `pattern` (grep -E) is already in it.
ensure_line() {
  local file="$1" line="$2" pattern="$3"
  touch "$file"
  grep -qE "$pattern" "$file" || printf '\n%s\n' "$line" >> "$file"
}

# Symlink $DOTFILES/$1 to $HOME/$1, backing up a real file that's in the way.
link() {
  local src="$DOTFILES/$1" dst="$HOME/$1"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mv "$dst" "$dst.bak.$(date +%Y%m%d-%H%M%S)"
    echo "Backed up existing $dst"
  fi
  ln -nfs "$src" "$dst"
}

link_dotfiles() {
  local f
  for f in .commonrc .commonbashrc .commonzshrc .gitrc .gitconfig .vimrc .tmux.conf .ideavimrc nuke-local-branches.sh; do
    link "$f"
  done

  ensure_line "$HOME/.bashrc" 'source "$HOME/.commonbashrc"' '\.commonbashrc'
  # login shells (tmux panes, ssh) read ~/.bash_profile instead of ~/.bashrc
  ensure_line "$HOME/.bash_profile" '[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"' '\.bashrc'
  if command -v zsh >/dev/null 2>&1; then
    ensure_line "$HOME/.zshrc" 'source "$HOME/.commonzshrc"' '\.commonzshrc'
  fi
}

detect_os() {
  if [ "$(uname -s)" = "Darwin" ]; then
    echo macos
  elif command -v apt-get >/dev/null 2>&1; then
    echo debian
  elif command -v dnf >/dev/null 2>&1; then
    echo fedora
  elif command -v yum >/dev/null 2>&1; then
    echo centos
  elif command -v pacman >/dev/null 2>&1; then
    echo arch
  else
    echo "Unsupported OS" >&2
    exit 1
  fi
}

# Install packages if missing, upgrade them if already installed.
install_packages() {
  case "$OS" in
    macos)  brew install "$@" && brew upgrade "$@" ;;
    debian) sudo apt-get update && sudo apt-get install -y "$@" ;;  # install also upgrades named packages
    fedora) sudo dnf install -y "$@" && sudo dnf upgrade -y "$@" ;;
    centos) sudo yum install -y "$@" && sudo yum update -y "$@" ;;
    arch)   sudo pacman -S --noconfirm "$@" ;;
  esac
}

# Clone a repo, or pull it if it's already there.
clone_or_pull() {
  local url="$1" dir="$2"
  if [ -d "$dir/.git" ]; then
    git -C "$dir" pull --ff-only
  else
    git clone --depth 1 "$url" "$dir"
  fi
}

install_tools() {
  mkdir -p "$HOME/.local/bin"

  case "$OS" in
    macos)
      install_packages git htop vim tmux curl wget ripgrep fd diff-so-fancy \
        zsh-syntax-highlighting zsh-autosuggestions zsh-completions
      ;;
    centos)
      install_packages git htop vim tmux curl patch wget xclip
      # Amazon Linux doesn't package fd/rg, so we ship prebuilt binaries
      ln -sf "$DOTFILES/binaries/amazon-ec2-linux-2023/fd" "$HOME/.local/bin/fd"
      ln -sf "$DOTFILES/binaries/amazon-ec2-linux-2023/rg" "$HOME/.local/bin/rg"
      ;;
    debian|fedora)
      install_packages git htop vim tmux curl patch wget xclip ripgrep fd-find
      ;;
    arch)
      install_packages git htop vim tmux curl patch wget xclip ripgrep fd
      ;;
  esac

  # Debian/Ubuntu name the fd binary `fdfind`
  if command -v fdfind >/dev/null 2>&1; then
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
  fi

  if [ "$OS" != macos ]; then
    clone_or_pull https://github.com/so-fancy/diff-so-fancy.git "$HOME/.diff-so-fancy"

    # node via nvm (on macOS, node comes from mise). The installer is safe to re-run.
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    # shellcheck disable=SC1091
    . "$NVM_DIR/nvm.sh"
    nvm install --lts
  fi

  # zoxide's installer always fetches the latest release into ~/.local/bin
  curl -fsSL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

  # fzf from git so every OS gets the same recent version; its installer won't duplicate rc lines
  clone_or_pull https://github.com/junegunn/fzf.git "$HOME/.fzf"
  "$HOME/.fzf/install" --key-bindings --completion --update-rc

  if command -v claude >/dev/null 2>&1; then
    claude update
  else
    curl -fsSL https://claude.ai/install.sh | bash
  fi
}

link_dotfiles
if [ "${SKIP_INSTALL:-0}" != 1 ]; then
  OS="$(detect_os)"
  echo "Detected OS: $OS"
  install_tools
fi
echo "Done. Open a new shell to pick up the changes."
