#!/bin/bash

# Script that creates an ASCII banner from the username of the logged in username
# The banner is displayed when the user logs in to the terminal

# Only run if the figlet command is available
if ! command -v figlet &> /dev/null
then
    echo "Figlet is not installed";
else
    # Get the username of the logged in username
    username=$(whoami)
    
    # Get the font.
    # If $HOME/.local/share/fonts/DOS Rebel.flf exist, use it, otherwise use the default font.
    if [ -f "$HOME/.local/share/fonts/DOS Rebel.flf" ]; then
        font="$HOME/.local/share/fonts/DOS Rebel.flf"
    else
        font="slant"
    fi
    
    # Create an ASCII banner using the username
    banner=$(figlet -f "${font}" "$username")
    
    # Display the banner when the user logs in to the terminal
    echo "$banner"
fi 
