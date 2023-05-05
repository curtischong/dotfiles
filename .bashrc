echo ".commonrc sourced in $( TIMEFORMAT=%R; time (source "$HOME/.commonrc") 2>&1 ) seconds"

alias sr="source $HOME/.bashrc && echo sourced bashrc;" # sr means: source .bashrc
alias vr="vim $HOME/.bashrc"  # vr means: vim .bashrc

[[ $- == *i* ]] && stty -ixon # Allows for forward search via ctrl + s

shopt -s autocd # allows you to cd into a directory by just typing its name
# e.g. typing ".." will cd into the parent directory

HISTCONTROL=ignorespace # don't remember commands that are ran and started with a space
HISTCONTROL=ignoredups # don't remember commands that are ran twice in a row

cd_to_last_open_dir(){
  if [ -f ~/.last_dir ]; then
          _cdd "`cat ~/.last_dir`"
  fi
}
PROMPT_COMMAND="cd_to_last_open_dir"

# fzf complete makefile commands: https://stackoverflow.com/a/71966611/4647924
complete -W "\`grep -oE '^[a-zA-Z0-9_.-]+[\\:]*[a-zA-Z0-9_.-]+:([^=]|$)' ?akefile | sort | uniq | sed 's/[^a-zA-Z0-9_.-]*$//' | sed 's/[\]//g' | fzf\`" make

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
