#!/bin/bash

rcfile=""

while [[ "$rcfile" != "~/.bashrc" && "$rcfile" != "~/.zshrc" ]]
do
  read -p "Which rc file do you want to use? (1 for .bashrc, 2 for .zshrc) " rcfile
  if [[ "$rcfile" == "1" ]]; then
    rcfile="~/.bashrc"
  elif [[ "$rcfile" == "2" ]]; then
    rcfile="~/.zshrc"
  fi
done

FILE_A="$1"
FILE_B="$2"

# Check if files exist
if [ ! -f "$FILE_A" ] || [ ! -f "$FILE_B" ]; then
    echo "Error: One or both files do not exist."
    exit 1
fi

# Check if the file is in a git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: This script must be run within a git repository."
    exit 1
fi

# Check if there are unstaged changes in file A
if git diff --quiet -- "$FILE_A"; then
    echo "No unstaged changes in $FILE_A"
else
    # Create a temporary file to store the changes
    TEMP_FILE=$(mktemp)

    # Save unstaged changes in file A to the temporary file
    git diff --unified=0 -- "$FILE_A" > "$TEMP_FILE"

    # Append changes from temporary file to file B
    cat "$TEMP_FILE" >> "$FILE_B"

    # Reset file A to its last committed state
    git checkout -- "$FILE_A"

    # Remove the temporary file
    rm "$TEMP_FILE"

    echo "Unstaged changes in $FILE_A have been appended to $FILE_B and reset in $FILE_A"
fi
