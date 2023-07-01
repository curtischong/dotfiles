#!/bin/bash


# Needed for cdd command (with fuzzy search)
# We need to install from source since amazon linux doesn't have the binary available
function install_fd_from_source(){
  #install cc linker (needed for rust)
  sudo yum install -y gcc

  # install rust
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  echo "installing fd from source"
  cargo install fd-find
}

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
            install_fd_from_source
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

if [[ "$distro" == "macOS" ]]; then
  if ! grep -q ".commonzshrc" ~/.zshrc; then
      echo "Error: .commonzshrc is not present in .zshrc please run link_dotfiles.sh first"
      exit 1
  fi
else
  if ! grep -q ".commonbashrc" ~/.bashrc; then
      echo "Error: .commonbashrc is not present in .bashrc please run link_dotfiles.sh first"
      exit 1
  fi
fi

echo "You have selected $distro"

echo "Installing core packages..."
$package_manager \
    git `#dont need to install git cause you needed git to install this repo` \
    htop \
    vim \
    tmux \
    curl \
    patch \
    wget \
    xclip `#TODO: check if we can do cat file | xclip -selection clipboard` \
    ripgrep `#just faster grep. And prettier coloring I think` \
    `# neovim - not sure if I should uncomment`

$package_manager fd-find || $package_manager fd `#really useful for showing all directories and feeding them into fzf` \


# install fzf like this because ec2 doens't have fzf indexed (also because I want it to change my bash configs to enable history search with fzf)
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install


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

if [ $distro != "macOS" ]; then
  source "$HOME/.bashrc"
fi
