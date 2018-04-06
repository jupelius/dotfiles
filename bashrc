# If not running interactively, don't do anything
[[ $- != *i* ]] && return

GIT_COMPLETION=""

if [ -f /usr/share/git/git-prompt.sh ]; then
    GIT_COMPLETION=/usr/share/git/git-prompt.sh
elif [ -f /usr/share/bash-completion/bash_completion ]; then
    GIT_COMPLETION=/usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    GIT_COMPLETION=/etc/bash_completion
fi

if [ -n "$GIT_COMPLETION" ]; then
    source "$GIT_COMPLETION"

    if [ -n "$SSH_CLIENT" ]; then
        PS1='[\[\e[1;37m\]\u\[\e[0;31m\]@\[\e[1;37m\]\h \[\e[0;32m\]\w\[\e[0;36m\]$(__git_ps1)\[\e[0m\]]\[\e[0;35m\]\$\[\e[0m\] '
    else
        PS1='[\[\e[1m\]\u@\h \[\e[0;32m\]\w\[\e[0;36m\]$(__git_ps1)\[\e[0m\]]\[\e[0;35m\]\$\[\e[0m\] '
    fi
else
    if [ -n "$SSH_CLIENT" ]; then
        PS1='[\[\e[1;37m\]\u\[\e[0;31m\]@\[\e[1;37m\]\h \[\e[0;32m\]\w\[\e[0m\]]\[\e[0;35m\]\$\[\e[0m\] '
    else
        PS1='[\[\e[1m\]\u@\h \[\e[0;32m\]\w\[\e[0m\]]\[\e[0;35m\]\$\[\e[0m\] '
    fi
fi

export HISTCONTROL=ignoredups
export TERM=xterm-256color
export XKB_DEFAULT_LAYOUT="fi"
export EDITOR=vim

# for tmux: export 256color
[ -n "$TMUX" ] && export TERM=screen-256color

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi

# tarball <tarball_name> <target>
alias tarball='tar cvzf'
alias ret='tmux attach'
alias ngrep='grep -n --color'
alias master="git checkout master"
alias gt="git status"
alias gl="git log -n 3"
alias gd="git diff"
alias gdn="git diff --name-only"
alias gdh="git diff HEAD~"
alias gdhn="git diff --name-only HEAD~"
alias gb="git branch"
alias telkkukiinni='xrandr --output HDMI1 --auto --right-of LVDS1'
alias telkkupois='xrandr --output HDMI1 --off'

ixcat() {
	if [ "$1" ]; then
		curl -F "f:1=<$1" ix.io
	else
		curl -F 'f:2=<-' ix.io 
	fi
}

sprungecat() {
	if [ "$1" ]; then
		curl -F sprunge=@- sprunge.us < "$1"
	else
		curl -F sprunge=@- sprunge.us
	fi
}

godir() {
	if [ "$1" ]; then
		if [ ! -d "$1" ]; then
			mkdir "$1"
		fi
		cd "$1" || return
	fi
}

skaalaa() {
    if [ $# -lt 3 ]; then
        echo "Usage: <GEOMETRY> <OUTPUT DIR> <FILE(S)>"
        return 1
    fi

    GEOMETRY=$1
    OUTPUT=$2
    COUNT=0
    shift 2

    echo "Geometry is '$GEOMETRY', output directory is '$OUTPUT'"
    mkdir -p "$OUTPUT"
    while (( $# )); do
        echo "Scaling $1..."
        if ! convert -scale "$GEOMETRY" "$1" "$OUTPUT/$1"; then
            echo "convert returned $?! Exiting..."
            return
        fi
        (( COUNT=COUNT+1 ))
        shift
    done

    echo "Succesfully scaled $COUNT files."
}
