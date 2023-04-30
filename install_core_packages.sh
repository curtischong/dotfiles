
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

if [ $distro == "macOS" ]; then
    while true; do
        echo "Do you want to install the following packages? (y/n)"
        read -p "zsh-syntax-highlighting, zsh-autosuggestions, zsh-completions, zsh-history-substring-search: " yn
        case $yn in
            [Yy]* )
                brew install zsh-syntax-highlighting zsh-autosuggestions zsh-completions zsh-history-substring-search;
                $personal_zshrc = ~/.personalrc;

                echo '---- Start of install_core_packages.sh ----' >> $personal_zshrc;
                echo 'export HOMEBREW_PREFIX=/opt/homebrew' >> $personal_zshrc;

                # https://formulae.brew.sh/formula/zsh-syntax-highlighting
                echo 'source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> $personal_zshrc;

                # https://formulae.brew.sh/formula/zsh-autosuggestions
                echo 'source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh' >> $personal_zshrc;
                # If you receive "highlighters directory not found" error message, you may need to add the following to your .zshenv:
                # export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/highlighters
                echo '# bind CTRL+O to forward-word so we can accept one token at a time (rather than the entire line)' >> $personal_zshrc;
                echo 'bindkey ^O forward-word # https://stackoverflow.com/questions/2212203/moving-a-word-forward-in-z-shell' >> $personal_zshrc;

                # https://formulae.brew.sh/formula/zsh-completions
                echo ' if type brew &>/dev/null; then
     FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

     autoload -Uz compinit
     compinit
    fi' >> $personal_zshrc;
                # You may also need to force rebuild `zcompdump`:
                # 
                #     rm -f ~/.zcompdump; compinit
                # 
                # Additionally, if you receive "zsh compinit: insecure directories" warnings when attempting
                # to load these completions, you may need to run this:
                # 
                #     chmod -R go-w '$HOMEBREW_PREFIX/share/zsh'


                # https://formulae.brew.sh/formula/zsh-history-substring-search
                source $HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh >> $personal_zshrc;

                echo '---- End of install_core_packages.sh ----' >> $personal_zshrc;

                break;;
            [Nn]* ) echo "Skipping..."; break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
fi