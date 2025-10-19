#!/bin/bash

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
        echo -e "\033[1;34m$1\033[0m"
    else
        $1
    fi
}

# 1. symlink (full)
# 2. original (full)
create_symlink()
{
    echo "Creating symlink $2"
    run "ln -s $1 $2"
}

# 1. local dir
# 2. symlink dir
create_symlinks()
{
    dot_files=`ls -A $1`
    for dotfile in $dot_files; do
        echo ""
        ls -A $2 | grep $dotfile > /dev/null
        if [[ $? == 1 ]]; then
            create_symlink $(pwd)/$1/$dotfile $2/$dotfile
        else
	    if [[ $CLEAN == 1 || $FRESH == 1 ]]; then
                echo "Deleting symlink $2/$dotfile"
		run "rm $2/$dotfile"
                if [[ $FRESH == 1 ]]; then
                    create_symlink $(pwd)/$1/$dotfile $2/$dotfile
                fi
                continue
	    fi

            echo "$2/$dotfile already exists"
        fi
    done
}

# Create symlinks for each dotfile in .config
create_symlinks .config ~/.config
create_symlinks tilde ~
