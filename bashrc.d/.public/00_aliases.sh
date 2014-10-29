# miscellanious aliases I like

# my aliases
alias h=history
alias la="ls -a"
#alias ll="ls -l -h"

#typo fixes
alias Cd="cd"
alias Ls="ls"
alias sl="ls"
alias lscd="cdls"
alias vi="vim"

#make everything human readable by default
alias df='df --human-readable'
alias du='du --human-readable'
alias ls='ls --color=auto'

# make everything safe
alias rm="rm --preserve-root"
alias cp='cp --interactive'
alias mv='mv --interactive'
alias ln='ln --interactive'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

# Easier navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias -- -='cd -'

# prevent a mistake I constantly make aka "cd cd directory"
# function cd() {
#     local folder_name
#     if [ "cd" == "$1" ]; then
#         folder_name="$2"
#     else
#         folder_name="$1"
#     fi
#     command cd ${folder_name}
# }

# execute both of these commands quicker
function cdls() {
    cdls="cd $1; ls"
}

# grep through the make files
function mgrind() {
    if [ $2 ]; then
        shift 1
        folders="$@"
    else
        folders="."
    fi

    grep $1 `find ${folders} -name "?akefile*"` 2> /dev/null
}

# grep through the cmake files
function cgrind() {
    if [ $2 ]; then
        shift 1
        folders="$@"
    else
        folders="."
    fi

    grep $1 `find ${folders} -name "CMake*"` 2> /dev/null
}


# sources a cscope.out further up in the file directories
function cscope_source() {
    if [ -z "$1" ]; then
        file_name="cscope.out"
    else
        file_name="$1"
    fi

    CSCOPE_DB=
    prev_prev_dir=${OLDPWD}
    prev_dir=${PWD}
    while [ / != "${PWD}" ]; do
        if [ -e "${file_name}" ]; then
            CSCOPE_DB="${PWD}/${file_name}"
            export CSCOPE_DB
            echo "Using ${file_name} found in ${PWD}"
            OLDPWD=${prev_dir}
            break
        fi 
        cd ..
    done
    cd ${prev_dir}
    OLDPWD=${prev_prev_dir}

    if [ -z ${CSCOPE_DB} ]; then
        echo "No cscope file found."
    fi
}

# create a cscope.out
function cscope_generate() {
    rm cscope.files > /dev/null
    find ${PWD} -name '*.c'   \
             -o -name '*.cc'  \
             -o -name '*.h'   \
             -o -name '*.hpp' \
             -o -name '*.hxx' \
             -o -name '*.cpp' \
             -o -name '*.cxx' > cscope.files
    if [ $? == 127 ]; then
        rm cscope.files > /dev/null
    else
        cscope -b -q
    fi
}


# go backwards to a directory
function bd() {
    if [ -z "$1" ]; then
        cd ..
        return
    else
        file_name="$1"
    fi

    prev_prev_dir=${OLDPWD}
    prev_dir=${PWD}
    while :; do
        if [ -e "${file_name}" ]; then
            cd ${file_name}
            OLDPWD=${prev_dir}
            return
        fi 

        if [ / == "${PWD}" ]; then
            break;
        else
            cd ..
        fi
    done

    cd ${prev_dir}
    OLDPWD=${prev_prev_dir}

}

# add tab completion
# Currently folder names with spaces and tab completing multiple levels are broken
_bd() {
    COMPREPLY=( $(compgen -d "${COMP_WORDS[COMP_CWORD]}") )

    prev_prev_dir=${OLDPWD}
    prev_dir=${PWD}
    while :; do
        COMPREPLY+=( $(compgen -d "${COMP_WORDS[COMP_CWORD]}") )
        if [ / == "${PWD}" ]; then
            break;
        else
            cd ..
        fi
    done

    cd ${prev_dir}
    OLDPWD=${prev_prev_dir}
}

complete -o nospace -F _bd -S / bd

shopt -s extglob

extract() {
    local c e i

    (($#)) || return

    for i; do
        c=''
        e=1

        if [[ ! -r $i ]]; then
            echo "$0: file is unreadable: \`$i'" >&2
            continue
        fi

        case $i in
            *.t@(gz|lz|xz|b@(2|z?(2))|a@(z|r?(.@(Z|bz?(2)|gz|lzma|xz)))))
            c=(bsdtar xvf);;
            *.7z)  c=(7z x);;
            *.Z)   c=(uncompress);;
            *.bz2) c=(bunzip2);;
            *.exe) c=(cabextract);;
            *.gz)  c=(gunzip);;
            *.rar) c=(unrar x);;
            *.xz)  c=(unxz);;
            *.zip) c=(unzip);;
            *)     echo "$0: unrecognized file extension: \`$i'" >&2
            continue;;
        esac

        command "${c[@]}" "$i"
        ((e = e || $?))
    done
    return "$e"
}

