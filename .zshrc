HISTFILESIZE=1000000
HISTSIZE=1000000

alias sz='source ~/.zshrc && echo sourced zshrc;'
alias vz='vim ~/.zshrc'
alias rmoldbranches='git branch --merged | grep -v \* | xargs git branch -D'

alias gpl='git pull'
alias gp='git push && echo "git push"'
alias gpf='git push --force-with-lease && echo "git push --force-with-lease"'
alias gps='git push --set-upstream origin'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcm='git commit -m'
alias gc='git commit --amend --no-edit --date=now && echo "git commit --amend --no-edit --date=now"'
alias gf='git fetch origin && echo "fetched origin"'
alias grm='gf && git rebase origin/main || git rebase origin/master'
alias gr='git rebase --onto'
alias grl='git reflog'
alias gl='git log'
alias gs='git status'

bindkey -v # for vi in terminal
bindkey "^?" backward-delete-char # fixes a bug that prevents you from hitting backspace in insert mode

setopt autocd # setting up autocd
function pd { cd ${PWD%/$1/*}/$1; } # cd to a parent directory

# reverse search
bindkey '^r' history-incremental-search-backward
bindkey '^s' history-incremental-search-forward

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This    loads nvm bash_completion
