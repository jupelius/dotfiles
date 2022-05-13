#!/usr/bin/env bash

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_SUFFIX="_backup"

_copy()
{
    echo "Copy '$1' to '$2'? (Y/n)"
    read -sn 1 choice
    [[ "$choice" != "n" && "$choice" != "N" ]] && cp -v -b --suffix="${BACKUP_SUFFIX}" "${THISDIR}/$1" "$2"
}

_copy bash_profile ~/.bash_profile
_copy bashrc ~/.bashrc
_copy rc.lua ~/.config/awesome/
_copy tmux.conf ~/.tmux.conf
_copy vimrc ~/.vim/vimrc
_copy Xresources ~/.Xresources
