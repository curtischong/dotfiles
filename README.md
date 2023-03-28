# dot_files

### TODO:
- add `git rebase --continue/--abort to .crc`
- add `git push --set-upstream origin`
- figure out if you can get mac to also read this directory when looking at dot files
- This would be really good because I would no longer need to move all dot files to the root directory (and I can keep files updated with version control)
- Add a command to recursively fuzzy search for a file name under the current directory (with a pretty dropdown)

### Installation:

For macOS the default shell is now zsh. Set it to bash for your bashrc to work: https://www.google.com/amp/s/www.howtogeek.com/444596/how-to-change-the-default-shell-to-bash-in-macos-catalina/amp/

##### Vim

`:source %`

##### Bash_rc

`curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash`

##### Git

` git config --global help.autocorrect 1`

##### zsh

1. `apt install zsh`
2. Change the default shell to zsh<br>
   `chsh -s /usr/bin/zsh root`
3. Install oh my zsh<br>
   `wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh`
4. Manual powerlevel10k installation<br>
   `git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>! ~/.zshrc`
5. log out, then log in. Provide the following answers:<br>
   5 yeses<br>
   lean<br>
   unicode<br>
   256 colors<br>
   no (show current time)<br>
   2 lines<br>
   dotted<br>
   left (prompt frame)<br>
   lightest (connection frame color)<br>
   compact (prompt spacing)<br>
   few icons<br>
   concise (prompt flow)<br>
   no (enable transient prompt)<br>
   verbose (instant prompt mode)<br>
   yes (apply changes to .zshrc<br>
6. append .zshrc in this dir to .zshrc. (Note: Your configs need to appended cause powerlevel10k overwrites flags like vi mode)<br>
   `cat ~/dot_files/.zshrc >> ~/.zshrc`
7. Make the terminal look nicer<br>
   `vim ~/.p10k.zsh`<br>
   search for `DIR_FOREGROUND` and change to `227` (yellow)<br>
   search for `ANCHOR_FOREGROUND` and change to `173` (red)<br>

8. log out. then log in.

TODO: install https://github.com/wting/autojump and https://github.com/zsh-users/zsh-autosuggestions
also figure out how to export zsh cnofig

##### JetBrains

1. Click `File | Manage IDE Settings | Import Settings`
2. Import the jetbrains settings zip
   - You can update the settings with: `File | Manage IDE Settings | Export Settings`

##### IDEAVim

- Place `.ideavimrc` in your home directory: `cp .ideavimrc ~/`
  - You may need to restart the IDE.
