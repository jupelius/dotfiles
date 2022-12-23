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
        "https://github.com/dense-analysis/ale"
        "https://github.com/preservim/nerdtree"
        "https://github.com/ervandew/supertab"
        "https://github.com/preservim/tagbar"
        "https://github.com/tomtom/tlib_vim"
        "https://github.com/MarcWeber/vim-addon-mw-utils"
        "https://github.com/vim-airline/vim-airline"
        "https://github.com/garbas/vim-snipmate"
        "https://github.com/honza/vim-snippets"
    )
    local colorsdir="$HOME/.vim/pack/colors/opt"
    local colorscheme="https://github.com/joshdick/onedark.vim.git"

    mkdir -p "$plugindir"

    pushd "$plugindir"
    for plugin in ${plugins[*]}
    do
        git clone "$plugin"
    done
    popd

    mkdir -p "$colorsdir"
    pushd "$colorsdir"
    git clone "$colorscheme"
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
