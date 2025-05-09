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
        "https://github.com/tpope/vim-fugitive"
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

make_directories() {
    mkdir -p ~/.vim/swap
    mkdir -p ~/.config/awesome
    mkdir -p ~/.config/alacritty
}

file_status() {
    if [ ! -e "$2" ]; then
        echo "$1:"
    else
        cmp -s "$1" "$2" && echo -e "\033[32;1m$1\033[0m:" || echo -e "\033[31;1m$1\033[0m:"
    fi
}

case "$1" in
    "run")
        make_directories

        _copy bash_profile ~/.bash_profile
        _copy bashrc ~/.bashrc
        _copy gitconfig ~/.gitconfig
        _copy rc.lua ~/.config/awesome/rc.lua
        _copy tmux.conf ~/.tmux.conf
        _copy vimrc ~/.vim/vimrc
        _copy Xresources ~/.Xresources
        _copy alacritty.toml ~/.config/alacritty/alacritty.toml

        confirm "Clone Vim plugins?" && deploy_vim_plugins
        ;;
    *)
        file_status bash_profile ~/.bash_profile
        file_status bashrc ~/.bashrc
        file_status gitconfig ~/.gitconfig
        file_status rc.lua ~/.config/awesome/rc.lua
        file_status tmux.conf ~/.tmux.conf
        file_status vimrc ~/.vim/vimrc
        file_status Xresources ~/.Xresources
        file_status alacritty.toml ~/.config/alacritty/alacritty.toml

        echo -e "\nUsage:"
        echo    "  $0 <run> - copy files in place"
        ;;
esac
