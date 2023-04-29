source "$HOME/.commonrc"

# Quality of Life
alias grep="grep --color=always"

# alias vv='virtualenv venv' # quite dangerous
alias sv='source venv/bin/activate; echo activated venv on $(which python) $(python --version);'
alias sb='source ~/.bashrc && echo sourced bashrc;'
alias vb='vim ~/.bashrc'
alias rmoldbranches='git branch --merged | grep -v \*     | xargs git branch -D'

[[ $- == *i* ]] && stty -ixon # Allows for forward search via ctrl + s

set -o vi

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
