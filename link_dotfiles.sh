#!/bin/bash

filesToLink=(
  .commonrc
  .gitrc
  .gitconfig
  .vimrc
  .tmux.conf
  .ideavimrc
  nuke-local-branches.sh
)

env_type="$(basename $SHELL)"

if [[ "$env_type" != "bash" && "$env_type" != "zsh" ]]; then
    echo "Error: run this script using 'bash' or 'zsh'" >&2
    exit 1
fi


if [ "$env_type" = "bash" ]; then
  filesToLink+=(".commonbashrc")
else
  filesToLink+=(".commonzshrc")
fi

# link all files to $HOME directory
# https://opensource.com/article/19/3/move-your-dotfiles-version-control
for file in "${filesToLink[@]}"; do
  ln -nfs "$PWD/$file" "$HOME/$file"
done

if [ "$env_type" = "bash" ]; then
  echo "source $HOME/.commonbashrc" >> "$HOME/.bashrc"
  source "$HOME/.bashrc"
else
  echo "source $HOME/.commonzshrc" >> "$HOME/.zshrc"
  source "$HOME/.zshrc"
fi
