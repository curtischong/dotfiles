
source "$HOME/.crc"

alias sz='source ~/.zshrc && echo sourced zshrc;'
alias vz='vim ~/.zshrc'

#bindkey -v # for vi in terminal
bindkey "^?" backward-delete-char # fixes a bug that prevents you from hitting backspace in insert mode

setopt autocd # setting up autocd
function pd { cd ${PWD%/$1/*}/$1; } # cd to a parent directory

# reverse search
bindkey '^r' history-incremental-search-backward
bindkey '^s' history-incremental-search-forward

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion
