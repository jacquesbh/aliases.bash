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
export -f selfupdate

# List Directory Content
# ====================================================
export LS_ARGS='-Gh'
alias ls='ls $LS_ARGS'
function l() { /bin/ls $LS_ARGS -1 "$@"; }
export -f l

function ll() { /bin/ls $LS_ARGS -lO "$@"; }
export -f ll

function lll() { /bin/ls $LS_ARGS -lOe "$@"; }
export -f lll

function lla() { /bin/ls $LS_ARGS -lOa "$@"; }
export -f lla

# Manipulations
# ====================================================
alias mkdir='mkdir -p'

# Compression
# ====================================================
alias tar='gnutar'

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
export -f site

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
export -f mov2mp4

# Development
# ====================================================
# http_headers: get just the HTTP headers from a web page (and its redirects)
function http_headers() { /usr/bin/curl -I -L $@ ; }
export -f http_headers

# Simple "memory" script
function memory() {
    if [ $1 = '' ]; then
        file='memory'
    else
        file=$1
    fi
    cat ~/Desktop/$file.txt 2> /dev/null ; cat >> ~/Desktop/$file.txt
}
export -f memory

# Alias for tail -f
function tf() { clear; tail -f $@ ; }
export -f tf

# Mysql dump in .gz on Desktop
function dump()
{
    if [ $# = 0 ]; then
        echo "Usage: dump base [tables...]"
        return 65
    fi
    db=$1
    shift
    tables=''
    for name in $@; do
        if [ $tables != '' ]; then
            tables=${tables}-$name
        else
            tables=$name
        fi
    done
    datetime=`date "+%Y-%m-%d_%H%M"`
    if [ $tables != '' ]; then
        filename=${db}_${datetime}_${tables}.sql.gz
    else
        filename=${db}_${datetime}.sql.gz
    fi
    mysqldump $db $@ | gzip > ~/Desktop/$filename
}
export -f dump

# Restore a database
function restore()
{
    if [ $# -lt 2 ]; then
        echo "Usage: restore database file.sql.gz"
        return 65
    fi

    if [ -f $2 ]; then
        mysqladmin -f drop $1
        mysqladmin create $1
        gunzip -c $2 | mysql $1
    else
        echo "File not found."
    fi
}
export -f restore

# Vagrant
alias v='vagrant'
function vscreen ()
{
    vagrant ssh -- -t screen $@
}

# Development - MAGENTO
# ====================================================

# Retrieve magento extension from Magento Connect 2.0
function getmage()
{
    # Usage example for http://connect20.magentocommerce.com/community/Fooman_Speedster-2.0.8 :
    # getmage community Fooman_Speedster 2.0.8
    wget --directory-prefix=$HOME/Downloads/ http://connect20.magentocommerce.com/$1/$2/$3/$2-$3.tgz
}
export -f getmage

# Servers
# ====================================================
function server ()
{
    if [ $# -lt 1 ]; then
        echo 'Usage: server <server alias> [new]'
        return 64
    fi

    if [ "$2" = "new" ]; then
        ssh -t $1 screen -S jack
    elif [ "$2" = "-d" ]; then
        ssh -t $1 screen -dr jack
    else
        ssh -t $1 screen -r jack
    fi
}
export -f server

# Text handling
# ====================================================
# enquote: surround lines with quotes (useful in pipes) - from mervTormel
function enquote() { /usr/bin/sed 's/^/"/;s/$/"/' ; }
export -f enquote

# cat_pdfs: concatenate PDF files
# e.g. cat_pdfs -o combined.pdf file1.pdf file2.pdf file3.pdf
function cat_pdfs() { python '/System/Library/Automator/Combine PDF Pages.action/Contents/Resources/join.py' "$@" ; }
export -f cat_pdfs

# Searching
# ====================================================
# grepfind: to grep through files found by find, e.g. grepf pattern '*.c'
# note that 'grep -r pattern dir_name' is an alternative if want all files 
function grepfind() { find . -type f -name "$2" -print0 | xargs -0 grep "$1" ; }
export -f grepfind

# I often can't recall what I named this alias, so make it work either way: 
alias findgrep='grepfind'

# Grep with colors !
alias grep='grep --color'

# Finder
# ====================================================
# rm_DS_Store_files: removes all .DS_Store file from the current dir and below
alias rm_DS_Store_files='find . -name .DS_Store -exec rm {} \;'

alias o='open .'
alias treel='tree -L 1'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# System
# ====================================================
alias ipfw='sudo ipfw'
alias forward80='sudo /sbin/ipfw add 100 fwd 127.0.0.1,8080 tcp from any to me 80'
alias forward443='sudo /sbin/ipfw add 100 fwd 127.0.0.1,8443 tcp from any to me 443'
alias forward3306='sudo /sbin/ipfw add 100 fwd 127.0.0.1,3307 tcp from any to me 3306'

# If you need some scripts, use the ~/.dedicated.bash for it :)
if [ -f ~/.dedicated.bash ]; then
    source ~/.dedicated.bash
fi
