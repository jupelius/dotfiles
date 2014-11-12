# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#PS1='[\u@\h \W]\$ '
if [ -n "$SSH_CLIENT" ]; then
	PS1='[\[\e[1m\]\u@\h\[\e[0m\] \[\e[0;31m\]\w\[\e[0m\]]\[\e[0;35m\]\$\[\e[0m\] '
else
	PS1='[\[\e[1m\]\u@\h\[\e[0m\] \[\e[0;32m\]\w\[\e[0m\]]\[\e[0;35m\]\$\[\e[0m\] '
fi

export HISTCONTROL=ignoredups
export TERM=xterm-256color
# for tmux: export 256color
[ -n "$TMUX" ] && export TERM=screen-256color

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
fi

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
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

godir() {
	if [ "$1" ]; then
		if [ ! -d "$1" ]; then
			mkdir $1
		fi
		cd $1
	fi
}

export EDITOR=vim
export BROWSER=firefox
