# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#PS1='[\u@\h \W]\$ '
PS1='[\[\e[1m\]\u@\h\[\e[0m\] \[\e[0;32m\]\W\[\e[0m\]]\[\e[0;35m\]\$\[\e[0m\] '

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
alias fics-chess='xboard -ics -icshost freechess.org'

ixcat() {
	if [ "$1" ]
	then
		curl -F "f:1=<$1" ix.io
	else
		curl -F 'f:2=<-' ix.io 
	fi
}

export EDITOR=vim
