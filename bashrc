#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

export PS1="\e[1;31m\u@\h:\w\e[m$ "

alias grep="rg"
alias ls="exa"
alias cat="bat"
alias nano="micro"
alias vim="nvim"

export PATH=/home/will/.cargo/bin/:$PATH

if [[ $(ps --no-header --pid=$PPID --format=comm) != "fish" && -z ${BASH_EXECUTION_STRING} ]]
then
	shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=''
	exec fish $LOGIN_OPTION
fi
