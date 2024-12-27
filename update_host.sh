#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0"
    exit 1
fi

# Read the host name from the command-line argument
HOST_NAME=$1

# Prompt for the EC2 endpoint or IP address
echo "Please paste the EC2 endpoint or IP address:"
read HOST_ENDPOINT

# Check if the input looks like an EC2 endpoint or an IP address
if [[ "$HOST_ENDPOINT" =~ ^ec2-[0-9-]+\.compute-[0-9]+\.amazonaws\.com$ || "$HOST_ENDPOINT" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    # Create a temporary file for the modified config
    TMP_FILE=$(mktemp)

    # Flag to track whether the specified host has been found
    HOST_FOUND=0
    FOUND_LINE=0

    # Read .ssh/config line by line
    while IFS= read -r line
    do
        # Check for the specified host
        if [[ "$line" =~ "Host $HOST_NAME" ]]; then
            HOST_FOUND=1
            FOUND_LINE=1
            echo "$line" >> "$TMP_FILE"
        elif [[ "$HOST_FOUND" -eq 1 && "$line" =~ HostName ]]; then
            # Update the HostName line
            echo "    HostName $HOST_ENDPOINT" >> "$TMP_FILE"
            HOST_FOUND=0
        else
            # Copy the line as is
            echo "$line" >> "$TMP_FILE"
        fi
    done < ~/.ssh/config

    # if we never found the line, throw
    if [[ "$FOUND_LINE" != 1 ]]; then
        echo "never found the corresponding line. is the line prefixed as HOST not Host?" >&2
        exit 1
    fi

    # Move the temporary file to the original config file location
    mv "$TMP_FILE" ~/.ssh/config
    echo "$HOST_NAME updated to $HOST_ENDPOINT in .ssh/config"
    # Remove the temporary file if needed
    # rm "$TMP_FILE"
else
    echo "Error: The input does not contain a valid EC2 endpoint or IP address"
fi
