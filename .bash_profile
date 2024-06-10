#
# ~/.bash_profile
#

if [ -z "$GTK_THEME" ]; then
	[[ -f ~/.profile ]] && . ~/.profile
fi

[[ -f ~/.bashrc ]] && . ~/.bashrc
