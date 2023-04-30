source "$HOME/.commonrc"

alias sb='source ~/.bashrc && echo sourced bashrc;'
alias vb='vim ~/.bashrc'

[[ $- == *i* ]] && stty -ixon # Allows for forward search via ctrl + s

shopt -s autocd # allows you to cd into a directory by just typing its name
# e.g. typing ".." will cd into the parent directory

# git brach auto completion
test -f "$HOME/.git-completion.bash" && . $_

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
print_before_the_prompt () { # makes it so the terminal lines have color
  printf "\e[1;31m%s: \e[1;33m%s \e[1;92m%s \e[1;0m"  "$USER" "$PWD" "$(parse_git_branch)"
}
PROMPT_COMMAND=print_before_the_prompt

export PS1='\n->'
