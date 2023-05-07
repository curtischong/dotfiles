#!/bin/sh

filesToLink=(
  .commonrc
  .gitrc
  .gitconfig
  .vimrc
  .tmux.conf
  .ideavimrc
)

# ask the user if they want to use zsh or bash
while true; do
  read -p "zsh or bash? (zsh/bash):" env_type
  if [ "$env_type" = "zsh" ] || [ "$env_type" = "bash" ]; then
    break
  else
    echo "Invalid input. Please try again."
  fi
done

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
fi