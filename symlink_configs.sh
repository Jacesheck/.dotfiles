#!/bin/bash

BLUE="\033[1;34m"
GREEN="\033[0;32m"
ORANGE="\033[0;33m"
RED="\033[0;31m"
NC="\033[0m"

# Dry run "-d"
if [ $# -ne 0 ]; then
  for arg in "$@"; do
      if [[ $arg = "-d" ]]; then
          echo "DRY_RUN=1"
          DRY_RUN=1
      elif [[ $arg = "-f" ]]; then
          echo "FRESH=1" # Remove and install
	  FRESH=1
      elif [[ $arg = "-c" ]]; then
          echo "CLEAN=1" # Remove only
	  CLEAN=1
      fi
    # Add your checks or operations here
  done
fi

# 1. Command
run()
{
    if [[ $DRY_RUN == 1 ]]; then
        echo -e "$BLUE$1$NC"
    else
        $1
    fi
}

# 1. local (full)
# 2. global (full)
# 3. filename (notdir)
create_symlink()
{
    local dotfile=$3
    ls -A $2 | grep $dotfile > /dev/null
    if [[ $? == 1 ]]; then
        # Symlink doesn't yet exist
        echo -e "$GREEN\rCreating symlink $2$NC"
        run "ln -s $(pwd)/$1/$dotfile $2/$dotfile"
    else
        # Symlink exists
        if [[ $CLEAN == 1 || $FRESH == 1 ]]; then
            echo -e "$RED\rDeleting symlink $2/$dotfile$NC"
            run "rm -r $2/$dotfile"
            if [[ $FRESH == 1 ]]; then
                echo -e "$GREEN\rCreating symlink $2$NC"
                run "ln -s $(pwd)/$1/$dotfile $2/$dotfile"
            fi
        else
            echo -e "$ORANGE$2/$dotfile already exists$NC"
        fi
    fi
}

# 1. local dir
# 2. symlink dir
create_symlinks_dir()
{
    dot_files=`ls -A $1`
    for dotfile in $dot_files; do
        create_symlink $1 $2 $dotfile
    done
}

# Create symlinks for each dotfile in .config
create_symlinks_dir config ~/.config
create_symlinks_dir tilde ~
create_symlinks_dir etc /etc
create_symlink tmux-sessionizer ~/.local/bin tmux-sessionizer
