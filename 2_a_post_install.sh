#!/bin/bash

# Utilities
sudo pacman -S --noconfirm openssh wget arch-wiki-lite unzip rsync ed vim bash-completion


#Utilities
sudo pacman -S --noconfirm alsa-utils mc colordiff iotop pkgfile htop

#update pkgfile for command no found hook
sudo pkgfile --update

#dev tools
sudo pacman -S --noconfirm git mercurial svn cvs bzr perl python ruby go gcc nodejs tcl tk

#configure git
read -p "Git username: " git_username
git config --global user.name $git_username
read -p "Git email: " git_email
git config --global user.email $git_email
git config --global core.autocrlf input

#update ruby gems
sudo gem update --system
gem update

#windows name lookup
#sudo pacman -S --noconfirm avahi nss-mdns
#sudo systemctl enable avahi-daemon.service
#sudo bash -c "sed 's/^hosts: files dns myhostname/hosts: files myhostname mdns_minimal [NOTFOUND=return] dns/' /etc/nsswitch.conf > /etc/nsswitch.confback; mv /etc/nsswitch.confback /etc/nsswitch.conf"

#disable sleep on close
#sudo bash -c "sed 's/^#HandleLidSwitch=suspend/HandleLidSwitch=ignore/' /etc/systemd/logind.conf > /etc/systemd/logind.confback; mv /etc/systemd/logind.confback /etc/systemd/logind.conf"
#sudo bash -c "sed 's/^#HandleHibernateKey=hibernate/HandleHibernateKey=ignore/' /etc/systemd/logind.conf > /etc/systemd/logind.confback; mv /etc/systemd/logind.confback /etc/systemd/logind.conf"


#sync clock and enable network time daemon
#sudo pacman -S --noconfirm ntp
#sudo ntpd -qg
#sudo systemctl enable ntpd


#Get rid of annoying beep and enhance tab completion
cat > ~/.inputrc <<EOL
set bell-style none
set show-all-if-ambiguous on
EOL


#configure firewall
sudo pacman -S --noconfirm ufw
sudo ufw enable
sudo ufw default deny
sudo systemctl enable ufw


#lock the root user
sudo passwd -l root


# configure .bashrc
cat > ~/.bashrc <<EOL
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
EOL


# configure .vimrc
cat > ~/.vimrc <<EOL
" break compatability with vi
set nocompatible

" dont visually wrap long lines
set nowrap

" allow switching buffers without saving them first
set hidden

" always show line numbers
set number
" Show row and column info
set ruler

" expand the command and search pattern history
set history=1000

" set terminal title
set title

" start scrolling three lines before the end of screen
set scrolloff=3

" normal backspacing
set backspace=indent,eol,start

" use simple indenting based on previous line indent
set autoindent

" syntax highlighting and file-type specific support
syntax on
filetype on
filetype plugin on
filetype indent on

" Set tab width to 2, ensure that tabs are never autoconverted to spaces
" and indents are 2 columns
set tabstop=2
set softtabstop=2
set shiftwidth=2
set noexpandtab

" hightlight search terms
set hlsearch
" highlight as the search term is typed
set incsearch
" do case-sensitive search only if a capital letter is used
set ignorecase
set smartcase

" wrap at 79 columns
set textwidth=79
set colorcolumn=+1

" Highlight matching brace
set showmatch

" Set color scheme
colorscheme darkblue

" show trailing whitespace
" map W to w
" better open/closing brace/parens/quote support
" map caps to ctrl
" examine vimtutor
" figure out auto-completion 
EOL

#AUR helper
cd /tmp
wget https://aur.archlinux.org/packages/pa/package-query/package-query.tar.gz
tar xzf package-query.tar.gz
cd package-query
makepkg -si
cd ..
cd /tmp
wget https://aur.archlinux.org/packages/ya/yaourt/yaourt.tar.gz
tar xzf yaourt.tar.gz
cd yaourt
makepkg -si
cd ~
