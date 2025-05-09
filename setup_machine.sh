#!/bin/bash


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
    filesToLink+=(".commonzshrc")
  fi

  # link all files to $HOME directory
  # https://opensource.com/article/19/3/move-your-dotfiles-version-control
  for file in "${filesToLink[@]}"; do
    ln -nfs "$PWD/$file" "$HOME/$file"
  done

  if [ "$env_type" == "bash" ]; then
    echo "source $HOME/.commonbashrc" >> "$HOME/.bashrc"
    source "$HOME/.bashrc"
  else
    echo "source $HOME/.commonzshrc" >> "$HOME/.zshrc"
    source "$HOME/.zshrc"
  fi
}

link_dotfiles

options=("macOS (brew)" "Debian/Ubuntu (apt-get)" "Fedora (dnf)" "CentOS (yum)" "Arch Linux (pacman)")
echo "Select your Linux distribution from the following list:"
PS3="Enter choice number: "

select opt in "${options[@]}"
do
    case $opt in
        "macOS (brew)")
            distro="macOS"
            package_manager="brew install"
            break
            ;;
        "Debian/Ubuntu (apt-get)")
            distro="debian/ubuntu"
            package_manager="sudo apt-get install -y"
            sudo apt update # so we can find binaries like fd-find
            sudo snap install ripgrep --classic
            break
            ;;
        "Fedora (dnf)")
            distro="fedora"
            package_manager="sudo dnf install -y"
            break
            ;;
        "CentOS (yum)")
            distro="centos"
            package_manager="sudo yum install -y"
            #sudo yum install yum-utils # so we can use yum-config-manager. Commented for now since nothing uses it
            install_ec2_linux_prebuild_bin
            break
            ;;
        "Arch Linux (pacman)")
            distro="arch linux"
            package_manager="sudo pacman install -y"
            break
            ;;
        *) echo "Invalid input. Please choose a number between 1 and ${#options[@]}";;
    esac
done

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
if [ $env_type == "bash" ]; then
  echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
  source ~/.bashrc
fi

if [ $distro != "macOS" ]; then
  echo "installing diff so fancy"
  sudo git clone https://github.com/so-fancy/diff-so-fancy.git ~/.diff-so-fancy
  echo 'PATH="$HOME/.diff-so-fancy/:$PATH"' >> ~/.bashrc
fi

# install fzf like this because ec2 doens't have fzf indexed (also because I want it to change my bash configs to enable history search with fzf)
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all


if [ $distro == "macOS" ]; then
    zshrc_location="$HOME/.zshrc";
    while true; do
        echo "Do you want to install the following packages? (y/n)"
        # disabling zsh-history-substring-search since it doesn't install properly on macOS (calls bash instead of zsh). I also don't think I would care enough to get it working rn
        # read -p "zsh-syntax-highlighting, zsh-autosuggestions, zsh-completions, zsh-history-substring-search: " yn
        read -p "zsh-syntax-highlighting, zsh-autosuggestions, zsh-completions: " yn
        case $yn in
            [Yy]* )
                echo '# ---- Start of install_core_packages.sh ----' >> $zshrc_location;
                echo 'export HOMEBREW_PREFIX=/opt/homebrew' >> $zshrc_location;
                echo 'export PATH=/opt/homebrew/bin:$PATH' >> $zshrc_location;

                #brew install zsh-syntax-highlighting zsh-autosuggestions zsh-completions zsh-history-substring-search;
                brew install zsh-syntax-highlighting zsh-autosuggestions zsh-completions;

                # https://formulae.brew.sh/formula/zsh-syntax-highlighting
                echo 'source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> $zshrc_location;

                # https://formulae.brew.sh/formula/zsh-autosuggestions
                echo 'source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh' >> $zshrc_location;
                # If you receive "highlighters directory not found" error message, you may need to add the following to your .zshenv:
                # export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/highlighters
                echo '# bind CTRL+O to forward-word so we can accept one token at a time (rather than the entire line)' >> $zshrc_location;
                echo 'bindkey ^O forward-word # https://stackoverflow.com/questions/2212203/moving-a-word-forward-in-z-shell' >> $zshrc_location;

                # https://formulae.brew.sh/formula/zsh-completions
                echo ' if type brew &>/dev/null; then
     FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

     autoload -Uz compinit
     compinit
    fi' >> $zshrc_location;
                # You may also need to force rebuild `zcompdump`:
                # 
                #     rm -f ~/.zcompdump; compinit
                # 
                # Additionally, if you receive "zsh compinit: insecure directories" warnings when attempting
                # to load these completions, you may need to run this:
                # 
                #     chmod -R go-w '$HOMEBREW_PREFIX/share/zsh'


                # https://formulae.brew.sh/formula/zsh-history-substring-search
                # source $HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh >> $zshrc_location;

                echo '# ---- End of install_core_packages.sh ----' >> $zshrc_location;

                break;;
            [Nn]* ) echo "Skipping..."; break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
fi

if [ $env_type == "bash" ]; then
  source "$HOME/.bashrc"
fi
# we have to link fd-find to fd here (at the end of the file) rather than right after the install command
# I think it's because the install command launches an async process to install fd, and by running the ln command here, it is more probable that the install command has finished (so which fdfind will return the correct path)
sudo mkdir -p "$HOME/.local/bin" && ln -s $(export PATH="/usr/bin:$PATH" && which fdfind) "$HOME/.local/bin/fd" # link the fd-find binary to fd
