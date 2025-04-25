#!/bin/bash
# the purpose of this script is to STREAMLINE ubuntu installation for computers to use.


# Needed for cdd command (with fuzzy search)
# We need to install from source since amazon linux doesn't have the binary available
function install_fd_from_source(){
  #install cc linker (needed for rust)
  sudo yum install -y gcc

  # install rust
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  source ~/.bashrc
  echo "installing fd from source"
  cargo install fd-find
}

function install_fd_from_bin(){
  # currently doesn't run on centos :(
  echo "installing fd from bin"
  # assume we're running bash
  sudo wget -P ~/ https://github.com/sharkdp/fd/releases/download/v8.7.0/fd-v8.7.0-arm-unknown-linux-musleabihf.tar.gz
  tar -xzf fd-v8.7.0-arm-unknown-linux-musleabihf.tar.gz
  rm fd-v8.7.0-arm-unknown-linux-musleabihf.tar.gz
  mv fd-v8.7.0-arm-unknown-linux-musleabihf .fd-find
  echo 'PATH="$HOME/.fd-find/:$PATH"' >> ~/.bashrc
}

  # I just prebuild it from cargo and just saved the binary
function install_ec2_linux_prebuild_bin(){
  echo "PATH=\"$PWD/binaries/amazon-ec2-linux-2023/:\$PATH\"" >> ~/.bashrc
}

function install_rg_for_centos(){
  # doesn't work :(
  sudo yum-config-manager --add-repo=https://copr.fedorainfracloud.org/coprs/carlwgeorge/ripgrep/repo/epel-7/carlwgeorge-ripgrep-epel-7.repo
  sudo yum install ripgrep
}

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
$package_manager xclip `#TODO: check if we can do cat file | xclip -selection clipboard`
$package_manager ripgrep  `#just faster grep. And prettier coloring I think` 
# not sure if I should uncomment:
#$package_manager neovim 

$package_manager fd-find || $package_manager fd `#really useful for showing all directories and feeding them into fzf` \

# install zoxide first, since if a command runs "cd", we will be able to change directory (since we override cd with zoxide)
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
# if [ $distro != "macOS" ]; then
#   echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
#   source ~/.bashrc
# fi

source $HOME/.cargo/env
cargo install git-delta
git config --global core.pager delta
git config --global interactive.diffFilter 'delta --color-only'
git config --global delta.navigate true
# git config --global merge.conflictStyle zdiff3 # zdiff3 is for zsh not bash I believe
git config --global merge.conflictStyle diff3
# if [ $distro != "macOS" ]; then
#   echo "installing diff so fancy"
#   sudo git clone https://github.com/so-fancy/diff-so-fancy.git ~/.diff-so-fancy
#   echo 'PATH="$HOME/.diff-so-fancy/:$PATH"' >> ~/.bashrc
# fi

# fzf is already installed in the system:
# install fzf like this because ec2 doens't have fzf indexed (also because I want it to change my bash configs to enable history search with fzf)
# git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
# ~/.fzf/install --all -y
mkdir -p $HOME/.local/share/fzf
wget --directory-prefix=$HOME/.local/share/fzf https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.bash
wget --directory-prefix=$HOME/.local/share/fzf https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.bash
chmod +x $HOME/.local/share/fzf/key-bindings.bash
chmod +x $HOME/.local/share/fzf/completion.bash
# echo 'source $HOME/.local/share/fzf/key-bindings.bash' >> ~/.bashrc
# echo 'source $HOME/.local/share/fzf/completion.bash' >> ~/.bashrc

# if [ $distro != "macOS" ]; then
source "$HOME/.bashrc"
# fi
# we have to link fd-find to fd here (at the end of the file) rather than right after the install command
# I think it's because the install command launches an async process to install fd, and by running the ln command here, it is more probable that the install command has finished (so which fdfind will return the correct path)
sudo mkdir -p "$HOME/.local/bin" && ln -s $(export PATH="/usr/bin:$PATH" && which fdfind) "$HOME/.local/bin/fd" # link the fd-find binary to fd
