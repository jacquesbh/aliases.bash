# My bash aliases
# Author: Jacques Bodin-Hullin
# Github : jacquesbh/aliases.bash
# License WTFPL
# Special thanks to Cameron Hayne (http://hayne.net)

# Update this script :)
selfupdate ()
{
    wget -O ~/.aliases.bash https://raw.github.com/jacquesbh/aliases.bash/master/.aliases.bash
    source ~/.aliases.bash
}

# List Directory Content
# ====================================================
export LS_ARGS='-Gh'
alias ls='ls $LS_ARGS'
l () { /bin/ls $LS_ARGS -1 "$@"; }
ll () { /bin/ls $LS_ARGS -lO "$@"; }
lll () { /bin/ls $LS_ARGS -lOe "$@"; }
lla () { /bin/ls $LS_ARGS -lOa "$@"; }

# Directories
# ====================================================
alias dl='cd ~/Downloads/'
alias desk='cd ~/Desktop/'

# Development
# ====================================================
# http_headers: get just the HTTP headers from a web page (and its redirects)
http_headers () { /usr/bin/curl -I -L $@ ; }

# Simple "memory" script
memory () {
    if [[ $1 == '' ]]; then
        file='memory'
    else
        file=$1
    fi
    cat ~/Desktop/$file.txt 2> /dev/null ; cat >> ~/Desktop/$file.txt
}

# Alias for tail -f
tf () { clear; tail -f $@ ; }

# Mysql dump in .gz on Desktop
dump ()
{
    if [[ $# = 0 ]]; then
        echo "Usage: dump base [tables...]"
        return 65
    fi
    db=$1
    shift
    tables=''
    for name in $@; do
        if [[ $tables != '' ]]; then
            tables=${tables}-$name
        else
            tables=$name
        fi
    done
    datetime=`date "+%Y-%m-%d_%H%M"`
    if [[ $tables != '' ]]; then
        filename=${db}_${datetime}_${tables}.sql.gz
    else
        filename=${db}_${datetime}.sql.gz
    fi
    mysqldump $db $@ | gzip > ~/Desktop/$filename
}

# Restore a database
restore ()
{
    if [[ $# < 2 ]]; then
        echo "Usage: restore database file.sql.gz"
        return 65
    fi

    if [[ -f $2 ]]; then
        mysqladmin -f drop $1
        mysqladmin create $1
        gunzip -c $2 | mysql $1
    else
        echo "File not found."
    fi
}

# Git
pp () { git pull && git push; }

# Development - MAGENTO
# ====================================================

# Retrieve magento extension from Magento Connect 2.0
getmage ()
{
    # Usage example for http://connect20.magentocommerce.com/community/Fooman_Speedster-2.0.8 :
    # getmage community Fooman_Speedster 2.0.8
    wget --directory-prefix=~/Downloads/ http://connect20.magentocommerce.com/$1/$2/$3/$2-$3.tgz
}

# Text handling
# ====================================================
# enquote: surround lines with quotes (useful in pipes) - from mervTormel
enquote () { /usr/bin/sed 's/^/"/;s/$/"/' ; }

# cat_pdfs: concatenate PDF files
# e.g. cat_pdfs -o combined.pdf file1.pdf file2.pdf file3.pdf
cat_pdfs () { python '/System/Library/Automator/Combine PDF Pages.action/Contents/Resources/join.py' "$@" ; }

# Searching
# ====================================================
# grepfind: to grep through files found by find, e.g. grepf pattern '*.c'
# note that 'grep -r pattern dir_name' is an alternative if want all files 
grepfind () { find . -type f -name "$2" -print0 | xargs -0 grep "$1" ; }
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
alias ...='cd ../..'
alias ..='cd ..'


# If you need some scripts, use the ~/.dedicated.bash for it :)
if [[ -f ~/.dedicated.bash ]]; then
    source ~/.dedicated.bash
fi
