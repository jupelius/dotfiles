#!/usr/bin/env bash

set -e

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_SUFFIX="_backup"

_copy()
{
    cp -v -b --suffix="${BACKUP_SUFFIX}" "${THISDIR}/$1" "$2"
}

_copy bash_profile ~/.bash_profile
_copy bashrc ~/.bashrc
_copy rc.lua ~/.config/awesome/
_copy tmux.conf ~/.tmux.conf
_copy vimrc ~/.vim/vimrc
_copy Xresources ~/.Xresources
