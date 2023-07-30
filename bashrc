#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

alias grep='rg'
alias ls='exa'
alias cat='bat'
alias nano='micro'

export PATH=/home/will/.cargo/bin/:$PATH
export PS1="\e[1;31m\u@\h:\w\e[m$ "
