#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PS1="\e[1;31m\u@\h:\w\e[m$ "

alias grep="rg"
alias ls="exa"
alias nano="micro"
alias vim="nvim"

if grep -qxv 'fish' /proc/$PPID/comm && [[ ${SHLVL} == [1,2] ]]
then
	shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=''
	exec fish $LOGIN_OPTION
fi
