# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -f /usr/share/git/git-prompt.sh ]; then
    source /usr/share/git/git-prompt.sh

    if [ -n "$SSH_CLIENT" ]; then
        PS1='[\[\e[1;37m\]\u\[\e[0;31m\]@\[\e[1;37m\]\h \[\e[0;32m\]\w\[\e[0;36m\]$(__git_ps1)\[\e[0m\]]\[\e[0;35m\]\$\[\e[0m\] '
    else
        PS1='[\[\e[1m\]\u@\h \[\e[0;32m\]\w\[\e[0;36m\]$(__git_ps1)\[\e[0m\]]\[\e[0;35m\]\$\[\e[0m\] '
    fi
else
    if [ -n "$SSH_CLIENT" ]; then
        PS1='[\[\e[1m\]\u@\h\[\e[0m\] \[\e[0;31m\]\w\[\e[0m\]]\[\e[0;35m\]\$\[\e[0m\] '
    else
        PS1='[\[\e[1m\]\u@\h\[\e[0m\] \[\e[0;32m\]\w\[\e[0m\]]\[\e[0;35m\]\$\[\e[0m\] '
    fi
fi

export HISTCONTROL=ignoredups
export TERM=xterm-256color
export XKB_DEFAULT_LAYOUT=fi

# for tmux: export 256color
[ -n "$TMUX" ] && export TERM=screen-256color

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
fi

# tarball <tarball_name> <target>
alias tarball='tar cvzf'
alias ret='tmux attach'

ixcat() {
	if [ "$1" ]; then
		curl -F "f:1=<$1" ix.io
	else
		curl -F 'f:2=<-' ix.io 
	fi
}

sprungecat() {
	if [ "$1" ]; then
		curl -F sprunge=@- sprunge.us < $1
	else
		curl -F sprunge=@- sprunge.us
	fi
}

godir() {
	if [ "$1" ]; then
		if [ ! -d "$1" ]; then
			mkdir $1
		fi
		cd $1
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
    mkdir -p $OUTPUT
    while (( $# )); do
        echo "Scaling $1..."
        convert -scale $GEOMETRY "$1" "$OUTPUT/$1"
        if (( $? )); then
            echo "convert returned $?! Exiting..."
            return
        fi
        let COUNT=$COUNT+1
        shift
    done

    echo "Succesfully scaled $COUNT files."
}

kt_upload() {
	if [ "$1" ]; then
		if [ $1 -eq 0 ]; then
			echo "Setting KTorrent upload rate to unlimited."
		else
			echo "Setting KTorrent upload rate to $1 KB/s."
		fi
		DISPLAY=:0 qdbus org.ktorrent.ktorrent /settings setMaxUploadRate $1
		DISPLAY=:0 qdbus org.ktorrent.ktorrent /settings apply
	else
		echo "No upload rate specified!"
	fi
}
