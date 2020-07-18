# dot_files

### Installation:

For macOS the default shell is now zsh. Set it to bash for your bashrc to work: https://www.google.com/amp/s/www.howtogeek.com/444596/how-to-change-the-default-shell-to-bash-in-macos-catalina/amp/

##### Vim
```:source %```

##### Bash_rc
```curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash```

##### zsh
1. `apt install zsh`
2. Change the default shell to zsh
`chsh -s /usr/bin/zsh root`
3. Install oh my zsh
`wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh`
4. Manual powerlevel10k installation
`git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>! ~/.zshrc`
5. log out, then log in.
answers:
5 yeses
lean
unicode
256 colors
no (show current time)
2 lines
dotted
left (prompt frame)
lightest (connection frame color)
compact (prompt spacing)
few icons
concise (prompt flow)
no (enable transient prompt)
verbose (instant prompt mode)
yes (apply changes to .zshrc
