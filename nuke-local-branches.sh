#!/bin/bash

# This is a useful script to remove old branches you're done with.
#
# This script finds all branches on your computer that are not present on the remote branch or are unmerged
# Next, this script will list them all out to you and ask you to select the branches on your local computer that
# you want to keep. The script will delete the other branches


# Fetch the remote branches
git fetch

# Get all local branches
local_branches=$(git branch | tr -d '* ' | tr '\n' ' ')

# Filter branches that are either missing on the remote repo or are unmerged
filtered_branches=()
for branch in $local_branches; do
    if [[ "$branch" != "main" ]] &&
        { ! git ls-remote --heads origin "$branch" &> /dev/null || ! git branch --merged | grep -q "$branch"; }; then
        filtered_branches+=($branch)
    fi
done

# Print the branches and their corresponding numbers
echo "The following branches are either not present on the remote or not merged:"
index=1
for branch in "${filtered_branches[@]}"; do
    echo "$index. $branch"
    index=$(( index + 1 ))
done
echo "0. I'm done"

# Ask user to select branches to keep
branches_to_keep=()
while true; do
    read -p "Enter the number of the branch you want to keep: " branch_number
    if [[ $branch_number == 0 ]]; then
        break
    elif (( branch_number < 1 || branch_number >= index )); then
        echo "Invalid choice. Please try again."
    elif [[ ! " ${branches_to_keep[@]} " =~ " $branch_number " ]]; then
        branches_to_keep+=($branch_number)
        echo "-------Branch kept: ${filtered_branches[$branch_number-1]}"

        echo "-------The branches you are keeping are:"
        for i in "${branches_to_keep[@]}"; do
            echo "${filtered_branches[$i-1]}"
        done
        echo "-------"

    else
        echo "You've already selected this branch to keep."
    fi
done

# Prepare to delete all other branches
echo ""
echo "The following branches will be deleted:"
for i in "${!filtered_branches[@]}"; do
    if [[ ! " ${branches_to_keep[@]} " =~ " $(($i+1)) " ]]; then
        echo ${filtered_branches[$i]}
    fi
done

# Ask for confirmation before deletion
read -p "Are you sure you want to delete these branches? [y/N]: " confirmation
case $confirmation in
    [yY])
        for i in "${!filtered_branches[@]}"; do
            if [[ ! " ${branches_to_keep[@]} " =~ " $(($i+1)) " ]]; then
                git branch -D ${filtered_branches[$i]}
            fi
        done
        ;;
    *)
        echo "Review the branches above and then manually run the delete commands."
        ;;
esac
