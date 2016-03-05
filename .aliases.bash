#!/usr/bin/env bash
# My bash aliases
# Author: Jacques Bodin-Hullin
# Github : jacquesbh/aliases.bash
# License WTFPL
# Special thanks to Cameron Hayne (http://hayne.net)

# Update this script :)
function selfupdate()
{
    wget -O ~/.aliases.bash https://raw.github.com/jacquesbh/aliases.bash/master/.aliases.bash
    source ~/.aliases.bash
}
export selfupdate

# List Directory Content
# ====================================================
export LS_ARGS='-Gh'
alias ls='ls $LS_ARGS'
function l() { /bin/ls $LS_ARGS -1 "$@"; }
export l

function ll() { /bin/ls $LS_ARGS -lO "$@"; }
export ll

function lll() { /bin/ls $LS_ARGS -lOe "$@"; }
export lll

function lla() { /bin/ls $LS_ARGS -lOa "$@"; }
export lla

# Manipulations
# ====================================================
alias mkdir='mkdir -p'

# Typos
# ====================================================
alias cim='vim'
alias vp='cp'
alias cd..='cd ..'

# Compression
# ====================================================
#alias tar='gnutar'

# Directories
# ====================================================
alias dl='cd ~/Downloads/'
alias desk='cd ~/Desktop/'
alias docs='cd ~/Documents/'
alias prez='cd ~/Presentations/'
alias drive='cd ~/Google\ Drive/'

# Projects
# ====================================================
function site ()
{
    cd ~/Sites
    if [[ $# > 0 ]]; then
        cd $@
    fi
}
export site

if [ "$SHELL" = "/bin/zsh" ]; then
    _site () { _files -W ~/Sites; }
    compdef _site site
fi

# Video
# ====================================================
# Convert .mov (QuickTime videos) to .mp4
function mov2mp4 ()
{
    base=`basename $1 .mov`
    ffmpeg -i $1 $base.mp4
}
export mov2mp4

# Development
# ====================================================
# http_headers: get just the HTTP headers from a web page (and its redirects)
function http_headers() { /usr/bin/curl -I -L $@ ; }
export http_headers

# Simple "memory" script
function memory() {
    if [ $1 = '' ]; then
        file='memory'
    else
        file=$1
    fi
    cat ~/Desktop/$file.txt 2> /dev/null ; cat >> ~/Desktop/$file.txt
}
export memory

# Alias for tail -f
function tf() { clear; tail -f $@ ; }
export tf

# Vagrant
alias v='vagrant'
function vmux ()
{
    vagrant ssh -- -A -t tmux $@
}

# VMWare
alias vmrun="/Applications/VMware\ Fusion.app/Contents/Library/vmrun"

function lsvm()
{
    find . -type f -iname "*.vmx" -exec grep displayname {} \; | cut -d = -f 2 | cut -d '"' -f 2
}
export lsvm

alias pbsort="pbpaste | sort | pbcopy"

# SSL Certificates (self signed)
function selfsignedssl()
{
    echo "Please fill the hostname: (example: monsieurbiz.com)"
    read hostname
    openssl genrsa -out $hostname.key 2048
    openssl req -new -x509 -nodes -sha256 -key $hostname.key -out _.$hostname.cert -days 3650 -subj "/C=FR/CN=*.$hostname"
    openssl req -new -x509 -sha256 -key $hostname.key -out $hostname.cert -days 3650 -subj "/C=FR/CN=$hostname"
}
export selfsignedssl


# Development - MAGENTO
# ====================================================

# Retrieve magento extension from Magento Connect 2.0
function getmage()
{
    # Usage example for http://connect20.magentocommerce.com/community/Fooman_Speedster-2.0.8 :
    # getmage Fooman_Speedster-2.0.8
    nb=`echo $1 | awk '{n=split($0,a,"-"); print n}'`
    v=`echo $1 | cut -d "-" -f $nb`
    nbb=`expr $nb - 1`
    n=`echo $1 | cut -d "-" -f -$nbb`
    wget --directory-prefix=$HOME/Downloads/ http://connect20.magentocommerce.com/community/$n/$v/$n-$v.tgz
}
export getmage

# Servers
# ====================================================
function server ()
{
    if [ $# -lt 1 ]; then
        echo 'Usage: server <server alias> [new|tmux args]'
        return 64
    fi

    server=$1
    shift

    if [ "$1" = "new" ]; then
        ssh -t $server tmux new-session -s "$server"
    elif [ ! "$1" ]; then
        ssh -t $server tmux attach -t "$server"
    else
        ssh -t $server tmux $@
    fi
}
export server

# Text handling
# ====================================================
# enquote: surround lines with quotes (useful in pipes) - from mervTormel
function enquote() { /usr/bin/sed 's/^/"/;s/$/"/' ; }
export enquote

# cat_pdfs: concatenate PDF files
# e.g. cat_pdfs -o combined.pdf file1.pdf file2.pdf file3.pdf
function cat_pdfs() { python '/System/Library/Automator/Combine PDF Pages.action/Contents/Resources/join.py' "$@" ; }
export cat_pdfs

# Searching
# ====================================================
# grepfind: to grep through files found by find, e.g. grepf pattern '*.c'
# note that 'grep -r pattern dir_name' is an alternative if want all files 
function grepfind() { find . -type f -name "$2" -print0 | xargs -0 grep "$1" ; }
export grepfind

# I often can't recall what I named this alias, so make it work either way: 
alias findgrep='grepfind'

# Grep with colors !
alias grep='grep --color'

# Finder
# ====================================================
# rm_DS_Store_files: removes all .DS_Store file from the current dir and below
alias rm_DS_Store_files='find . -name .DS_Store -exec rm {} \;'

alias o='open .'
alias tree='tree -C'
alias treel='tree -L 1'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Ping
# ====================================================
alias pg='ping google.com'

# Git
# ====================================================
alias g='git'
alias gs='git status'
alias gr='cd "$(git rev-parse --show-toplevel)"'
alias feat='git flow feature'
alias push='git push'
alias stash='git stash'
alias gv='git tag --contains=master'
function gh() {
    id=`git remote get-url --push origin | cut -d "@" -f 2 | cut -d : -f 2`
    open https://github.com/${id//\.git/}
}
export gh

# Security tools
alias mkpasswd='python -c "from passlib.hash import sha512_crypt; import getpass; print sha512_crypt.encrypt(getpass.getpass())"'

# If you need some scripts, use the ~/.dedicated.bash for it :)
if [ -f ~/.dedicated.bash ]; then
    source ~/.dedicated.bash
fi
