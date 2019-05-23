set -o vi

HISTFILESIZE=1000000
HISTSIZE=1000000

# colours for the terminal to differentiate between files and directories
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# git brach auto completion
test -f ~/.git-completion.bash && . $_

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
print_before_the_prompt () { # makes it so the terminal lines have color
  printf "\e[1;36m%s: \e[1;33m%s \e[1;92m%s \e[1;0m"  "$USER" "$PWD" "$(parse_git_branch)"
}
PROMPT_COMMAND=print_before_the_prompt

export PS1='\n->'
