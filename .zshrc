echo ".commonrc sourced in $( TIMEFORMAT=%R; time (source "$HOME/.commonrc") 2>&1 ) seconds"

alias sr="source $HOME/.zshrc && echo sourced zshrc;" # sr means: source .zshrc
alias vr="vim $HOME/.zshrc"  # vr means: vim .zshrc

#bindkey -v # for vi in terminal
bindkey "^?" backward-delete-char # fixes a bug that prevents you from hitting backspace in insert mode

# reverse search
bindkey '^r' history-incremental-search-backward
bindkey '^s' history-incremental-search-forward

setopt hist_ignore_all_dups # don't remember commands that are ran twice in a row
setopt hist_ignore_space # if a command starts with a space, it won't be added to the command history

# TODO: autocd will NOT remember your previous directory. unlike the cd_ alias. We should fix this
setopt autocd # allows you to cd into a directory by just typing its name
# e.g. typing ".." will cd into the parent directory

precmd (){
  if [ -f ~/.last_dir ]; then
          _cdd "`cat ~/.last_dir`"
  fi
}


# fzf complete makefile commands: https://stackoverflow.com/a/71966611/4647924
# but converted into zsh
_my_make_completion() {
  local options
  options=$(grep -oE '^[a-zA-Z0-9_.-]+[:]*[a-zA-Z0-9_.-]+:([^=]|$)' Makefile | sort | uniq | sed 's/[^a-zA-Z0-9_.-]*$//' | sed 's/[\\]//g' | fzf)
  reply=($options)
}
compdef _my_make_completion make # Register the completion function with the make command

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion

function parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

setopt prompt_subst # ensure prompt is reevaluated each time https://stackoverflow.com/questions/39689789/zsh-setopt-prompt-subst-not-working
PS1='$(printf "\e[1;31m%s: \e[1;33m%s \e[1;92m%s \e[1;0m"  "$USER" "$PWD" "$(parse_git_branch)")
->'
