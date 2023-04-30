
#!/bin/bash

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
$package_manager \
    git `#dont need to install git cause you needed git to install this repo` \
    vim \
    tmux \
    curl \
    wget \
    xclip `#TODO: check if we can do cat file | xclip -selection clipboard` \
    fzf `#fuzzy finding` \
    ripgrep `#just faster grep. And prettier coloring I think` \
    `# neovim - not sure if I should uncomment`

$package_manager fd-find || $package_manager fd `#really useful for showing all directories and feeding them into fzf` \



# TODO: consider installing the following for zsh
# zsh-syntax-highlighting \
# zsh-autosuggestions \
# zsh-completions \
# zsh-history-substring-sear