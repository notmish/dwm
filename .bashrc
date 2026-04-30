#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='lsd --color=auto'
alias la='lsd -a'
alias cmat='cmatrix -C white'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
