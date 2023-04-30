
echo "Select your Linux distribution from the following list:"
echo "0. macOS (brew)"
echo "1. Debian/Ubuntu (apt-get)"
echo "2. Fedora (dnf)"
echo "3. CentOS (yum)"
echo "4. Arch Linux (pacman)"

read distro_num

case $distro_num in
    0)
        distro="macOS"
        package_manager="brew"
        ;;
    1)
        distro="debian/ubuntu"
        package_manager="apt-get"
        ;;
    2)
        distro="fedora"
        package_manager="dnf"
        ;;
    3)
        distro="centos"
        package_manager="yum"
        ;;
    4)
        distro="arch linux"
        package_manager="pacman"
        ;;
    *)
        echo "Invalid input. Please choose a number between 1 and 4."
        exit 1
esac

echo "You have selected $distro and the package manager is $package_manager."

echo "Installing core packages..."
sudo $package_manager install -y \
    git `#dont need to install git cause you needed git to install this repo` \
    vim \
    tmux \
    curl \
    wget \
    xclip `#TODO: check if we can do cat file | xclip -selection clipboard` \
    fzf `#fuzzy finding` \
    ripgrep `#just faster grep. And prettier coloring I think` \
    fd-find `#really useful for showing all directories and feeding them into fzf` \
    `# neovim - not sure if I should uncomment`



# TODO: consider installing the following for zsh
# zsh-syntax-highlighting \
# zsh-autosuggestions \
# zsh-completions \
# zsh-history-substring-sear