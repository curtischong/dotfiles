#!/bin/bash
# the purpose of this script is to STREAMLINE ubuntu installation for computers to use.

function link_dotfiles(){
  filesToLink=(
    .commonrc
    .gitrc
    .gitconfig
    .vimrc
    .tmux.conf
    .ideavimrc
    nuke-local-branches.sh
  )

  env_type="$(basename $SHELL)"

  if [[ "$env_type" != "bash" && "$env_type" != "zsh" ]]; then
      echo "Error: run this script using 'bash' or 'zsh'" >&2
      exit 1
  fi


  if [ "$env_type" = "bash" ]; then
    filesToLink+=(".commonbashrc")
  else
    filesToLink+=(".commonbashrc")
  fi

  # link all files to $HOME directory
  # https://opensource.com/article/19/3/move-your-dotfiles-version-control
  for file in "${filesToLink[@]}"; do
    ln -nfs "$PWD/$file" "$HOME/$file"
  done

  if [ "$env_type" = "bash" ]; then
    echo "source $HOME/.commonbashrc" >> "$HOME/.bashrc"
    source "$HOME/.bashrc"
  else
    echo "source $HOME/.commonbashrc" >> "$HOME/.bashrc"
    source "$HOME/.bashrc"
  fi
}

link_dotfiles

distro="debian/ubuntu"
package_manager="sudo apt-get install -y"
sudo apt update # so we can find binaries like fd-find
sudo snap install ripgrep --classic

echo "You have selected $distro"

echo "Installing core packages..."
$package_manager git `#dont need to install git cause you needed git to install this repo`
$package_manager htop
$package_manager vim
$package_manager tmux
$package_manager curl
$package_manager patch
$package_manager wget
# not sure if I should uncomment:
#$package_manager neovim

# install zoxide first, since if a command runs "cd", we will be able to change directory (since we override cd with zoxide)
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
# if [ $distro != "macOS" ]; then
#   echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
#   source ~/.bashrc
# fi

source $HOME/.cargo/env

#cargo install git-delta
git config --global core.pager delta
git config --global interactive.diffFilter 'delta --color-only'
git config --global delta.navigate true
git config --global merge.conflictStyle diff3

# git config --global merge.conflictStyle zdiff3 # zdiff3 is for zsh not bash I believe



source "$HOME/.bashrc"
# we have to link fd-find to fd here (at the end of the file) rather than right after the install command
# I think it's because the install command launches an async process to install fd, and by running the ln command here, it is more probable that the install command has finished (so which fdfind will return the correct path)
#sudo mkdir -p "$HOME/.local/bin" && ln -s $(export PATH="/usr/bin:$PATH" && which fdfind) "$HOME/.local/bin/fd" # link the fd-find binary to fd


curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
source "$HOME/.bashrc"
nvm install --lts
npm install -g @anthropic-ai/claude-code
