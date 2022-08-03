#!/usr/bin/env bash

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_SUFFIX="_backup"

confirm() {
    echo "$@ (Y/n)"
    read -sn 1 choice
    [[ "$choice" != "n" && "$choice" != "N" ]]
}

_copy()
{
    confirm "Copy '$1' to '$2'?" && cp -v -b --suffix="${BACKUP_SUFFIX}" "${THISDIR}/$1" "$2"
}

deploy_vim_plugins() {
    local plugindir="$HOME/.vim/pack/plugins/start"
    local plugins=(
        "git@github.com:dense-analysis/ale.git"
        "git@github.com:preservim/nerdtree.git"
        "git@github.com:ervandew/supertab.git"
        "git@github.com:preservim/tagbar.git"
        "git@github.com:tomtom/tlib_vim.git"
        "git@github.com:MarcWeber/vim-addon-mw-utils.git"
        "git@github.com:vim-airline/vim-airline.git"
        "git@github.com:garbas/vim-snipmate.git"
        "git@github.com:honza/vim-snippets.git"
    )

    mkdir -p "$plugindir"

    pushd "$plugindir"
    for plugin in ${plugins[*]}
    do
        git clone "$plugin"
    done
    popd
}

_copy bash_profile ~/.bash_profile
_copy bashrc ~/.bashrc
_copy gitconfig ~/.gitconfig
_copy rc.lua ~/.config/awesome/
_copy tmux.conf ~/.tmux.conf
_copy vimrc ~/.vim/vimrc
_copy Xresources ~/.Xresources

confirm "Clone Vim plugins?" && deploy_vim_plugins
