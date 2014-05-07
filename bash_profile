# Exec awesome in vtty1
if [ -z $DISPLAY ] && [ $XDG_VTNR -eq 1 ]; then
	startx
fi

# set PATH so it includes user's private bin if it exists
if [ -d ~/bin ] ; then
	PATH=~/bin:"${PATH}"
fi

stty -ixon -ixoff

# include .bashrc if it exists
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi
