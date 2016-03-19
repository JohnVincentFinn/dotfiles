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

