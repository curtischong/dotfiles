#/bin/sh

while true; do
  read -p "zsh or bash? (zsh/bash):" env_type
  if [ "$env_type" = "zsh" ] || [ "$env_type" = "bash" ]; then
    break
  else
    echo "Invalid input. Please try again."
  fi
done

if [ "$env_type" = "bash" ]; then
  rm .zshrc
else
  rm .bashrc
fi

# use dotglob to exclude "." and  ".." directories
shopt -s dotglob && mv . ~/
