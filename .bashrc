# Quality of Life
alias grep="grep --color=always"

# alias vv='virtualenv venv' # quite dangerous
alias sv='source venv/bin/activate; echo activated venv on $(which python) $(python --version);'
alias sb='source ~/.bashrc && echo sourced bashrc;'
alias vb='vim ~/.bashrc'
alias rmoldbranches='git branch --merged | grep -v \*     | xargs git branch -D'

alias sz='source ~/.zshrc && echo sourced zshrc;'
alias vz='vim ~/.zshrc'
alias rmoldbranches='git branch --merged | grep -v \* | xargs git branch -D'

alias gpl='git pull'
alias gp='git push && echo "git push"'
alias gpf='git push --force-with-lease && echo "git push --force-with-lease"'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcm='git commit -m'
alias gc='git commit --amend --no-edit --date=now && echo "git commit --amend --no-edit --date=now"'
alias gf='git fetch origin && echo "fetched origin"'
alias grm='gf && git rebase origin/master'
alias gr='git rebase --onto'
alias grl='git reflog'
alias gl='git log'

[[ $- == *i* ]] && stty -ixon # Allows for forward search via ctrl + s

set -o vi

HISTFILESIZE=1000000
HISTSIZE=1000000
export HISTCONTROL=ignoredups # This ignores duplicate commands in .bash_history

# colours for the terminal to differentiate between files and directories
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# git brach auto completion
test -f ~/.git-completion.bash && . $_

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
print_before_the_prompt () { # makes it so the terminal lines have color
  printf "\e[1;31m%s: \e[1;33m%s \e[1;92m%s \e[1;0m"  "$USER" "$PWD" "$(parse_git_branch)"
}
PROMPT_COMMAND=print_before_the_prompt

export PS1='\n->'

[[ $- == *i* ]] && stty -ixon # Allows for forward search via ctrl + s
