#
# ~/.bashrc
#
[[ \$- != *i* ]] && return
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias diff='colordiff'
alias more='less'
alias df='df -h'
alias free='free -h'
alias du='du -c -h'
alias ping='ping -c 5'
alias youtube-dl='youtube-dl -t '
alias vi='vim'
alias top='htop'
PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\\$\[\e[m\]\[\e[1;37m\]'
eval \$(dircolors -b)
export VISUAL="/usr/bin/vim -p -X"
source /usr/share/doc/pkgfile/command-not-found.bash

# Less Colors for Man Pages
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
