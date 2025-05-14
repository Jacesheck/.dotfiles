#!/bin/bash

# Create symlinks for each dotfile in .config
dot_files=`ls .config/`
for dotfile in $dot_files; do
    ls ~/.config | grep $dotfile > /dev/null
    if [[ $? == 1 ]]; then
        echo "Creating symlink .config/$dotfile"
        ln -s $(pwd)/.config/$dotfile ~/.config/$dotfile
    else
        echo ".config/$dotfile already exists"
    fi
done
