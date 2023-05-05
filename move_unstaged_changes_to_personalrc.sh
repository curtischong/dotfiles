#!/bin/bash

function move_unstaged(){
  source="$1"
  destination="$2"

  # Check if files exist
  if [ ! -f "$source" ] || [ ! -f "$destination" ]; then
      echo "Error: Missing one of: $source $destination"
      exit 1
  fi

  # Check if the file is in a git repository
  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
      echo "Error: This script must be run within a git repository."
      exit 1
  fi

  # Check if there are unstaged changes in source
  if git diff --quiet -- "$source"; then
      echo "No unstaged changes in $source"
  else
      # Create a temporary file to store the changes
      TEMP_FILE=$(mktemp)

      # Save unstaged changes in file A to the temporary file
      git diff --unified=0 -- "$source" > "$TEMP_FILE"

      # Append changes from temporary file to file B
      cat "$TEMP_FILE" >> "$destination"

      # Reset file A to its last committed state
      git checkout -- "$source"

      # Remove the temporary file
      rm "$TEMP_FILE"

      echo "Unstaged changes in $source have been appended to $destination and reset in $source"
  fi
}
move_unstaged .bashrc ~/.personalrc
move_unstaged .zshrc ~/.personalrc
