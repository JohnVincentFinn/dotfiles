
# Author: John Finn
# Helps to manage multiple workspaces

# commands
# ws my_workspace [my_folder]     Jumps to the correct machine, workspace and folder
# switch_workspace                Same as above command
# list_workspaces                 Lists all the workspace information
# add_workspace [my_workspace]    Adds a workspace to the list
# clear_workspaces
#
# remember my_folder              Remembers a folder for later
# jump  my_folder                 Jumps to the remembered folder
# forget my_folder                Removes the remembered folder
# list_memories
#
# limitations:
# Removing workspaces isn't really implemented so it has to be done by hand
# workspaces must have unique names they cannot just be unique per machine
# cannot yet learn new files that are comonly used 
# you must jump into a workspace. It cannot automatically be discovered
# prompt integration is not complete
#
# TODO
# remove workspaces
# integrate ctrl-z style directory learning
# check if the current path is in the current workspace before executing commands
# 

# variables allow different locations for the data to be configured
workspace_files=~/.workspaces
workspace_conf=${workspace_files}/workspace_conf # stores all the workspaces
workspace_data=.workspace_data    # directory created in workspace's root to link to it's data

mkdir -p ${workspace_files}

# set when a workspace is switched to
current_workspace=
current_workspace_name=

# functions to retrieve specific workspace info these are internal commands
#new_workspace_path=$(grep "^\([[:alnum:]_/-]\+ \+\)\+${new_workspace_name}$" ${workspace_files}/remembered_workspaces | cut -d" " -f1)
#new_workspace_hosts=$(grep "^\([[:alnum:]_/-]\+ \+\)\+${new_workspace_name}$" ${workspace_files}/remembered_hosts | cut -d" " -f1)
function _get_workspace_names() {
    local filter names
    if [ -z "$1" ]; then
        filter=
    else
        filter=$1
    fi
    names=($(awk '{ print $2 }' < ${workspace_files}/remembered_workspaces))
    echo ${names}
}

# filtered based off workspace name
function _get_workspace_hosts() {
    local filter hosts
    if [ -z "$1" ]; then
        filter=
    else
        filter=$1
    fi
    hosts=($(awk '{ print $1 }' < ${workspace_files}/remembered_hosts))
    echo ${hosts}
}

# filtered based off workspace name
function _get_workspace_directories() {
    local filter directories
    if [ -z "$1" ]; then
        filter=
    else
        filter=$1
    fi
    directories=($(awk '{ print $1 }' < ${workspace_files}/remembered_workspaces))
    echo ${directories}
}


function add_workspace() {
    local workspace_path workspace_host workspace_name
    workspace_path=${PWD}
    workspace_host=${HOSTNAME}
    if [ -z "$1" ]; then
        workspace_name=${PWD##*/}
    else
        workspace_name=$1
    fi

    # TODO: make sure this workspace name doesn't already exist
    if [ -d "${workspace_name}" ]; then
        echo "Workspace ${workspace_name} appears to exist. Come up with a new name."
        return
    else 
        echo "Adding ${workspace_name} to the list of known workspaces."
    fi

    mkdir -p ${workspace_files}/${workspace_name} &> /dev/null
    ln -s ${workspace_files}/${workspace_name} ${workspace_path}/${workspace_data}

    echo "root ${PWD}" >> ${workspace_files}/${workspace_name}/remembered_files
    echo "${workspace_name} (root|${workspace_path}) " >> ${workspace_files}/remembered_files
    echo "${workspace_path} ${workspace_name}" >> ${workspace_files}/remembered_workspaces
    echo "${workspace_host} ${workspace_name}" >> ${workspace_files}/remembered_hosts

    echo "${workspace_name} ${workspace_path} ${workspace_host}" >> ${workspace_conf}

}

alias ws="switch_workspace"
function switch_workspace() {
    local new_workspace_path new_workspace_host new_workspace_name
    if [ -z "$1" ]; then
        new_workspace_name="default"
    #elif [ "-" == "$1" ]; then
    #    new_workspace_name=${previous_workspace_name}
    else
        new_workspace_name=$1
    fi

    #shift

    new_workspace_path=$(grep "^\([[:alnum:]_/-]\+ \+\)\+${new_workspace_name}$" ${workspace_files}/remembered_workspaces | cut -d" " -f1)
    new_workspace_hosts=$(grep "^\([[:alnum:]_/-]\+ \+\)\+${new_workspace_name}$" ${workspace_files}/remembered_hosts | cut -d" " -f1)

    if [ -n "${new_workspace_path}" ] && [ -n "${new_workspace_hosts}" ]; then
        if [ "$HOSTNAME" != ${new_workspace_hosts} ]; then 
            exec ssh -Yt ${new_workspace_hosts} "env startup_cmd='ws ${new_workspace_name} $2' bash"
        else
            current_workspace=${new_workspace_path}
            current_workspace_name=${new_workspace_name}
            cd ${current_workspace}
            cscope_source

            #if cscope_source did not find a cscope file we should create one
            #generate syntastic files as well

            printf "\033k${new_workspace_name}\033\\"
            #if ! { [ "$TERM" = "screen" ] && [ -n "$TMUX" ]; } then
            #    tmux rename-window "$1"
            #fi
        fi
        if [ -n "${2}" ]; then
            jump ${2}
        fi
    else
cat << EOF
${new_workspace_name} is not found in your remembered workspaces.
Go to the workspace's directory and type "add_workspace <name>"
This will cause the directory to be associated with that workspace name.
EOF
    fi
}

# add tab completion
_switch_workspace() {
    cur=${COMP_WORDS[COMP_CWORD]}
    prev=${COMP_WORDS[COMP_CWORD-1]}
    COMPREPLY=( $(compgen -W "$(awk '{ print $2 }' < ${workspace_files}/remembered_workspaces)" "${cur}") )
    # if a there is already a workspace name entered we are jumping somewhere
    # COMPREPLY=( $(compgen -W "$(awk '{ print $1 }' < ${workspace_files}/${prev}/remembered_files)" "${COMP_WORDS[COMP_CWORD]}") )
}

complete -F _switch_workspace switch_workspace
complete -F _switch_workspace ws

function remove_workspace() {
    echo "remove_workspace is not yet supported."
    echo "If you want it email me."
    echo "If you really want it make it yourself then email me."
    return
    local remove_workspace_name
    if [ -n "$1" ]; then
        remove_workspace_name=${1##*/}
    else
        remove_workspace_name=${current_workspace_name##*/}
    fi

    rm --preserve-root -recursive ${workspace_files}/${remove_workspace_name}

    awk name=${remove_workspace_name} '/^name/ { print $1," ",$2," ",$3 }' < workspaces.conf

}

# add tab completion
_remove_workspace() {
    COMPREPLY=( $(compgen -W "$(awk '{ print $2 }' < ${workspace_files}/remembered_workspaces)" "${COMP_WORDS[COMP_CWORD]}") )
}

complete -F _remove_workspace remove_workspace

function list_workspaces() {
    local names directories hosts
    names=$(_get_workspace_names)
    directories=$(_get_workspace_directories)
    hosts=$(_get_workspace_hosts)

    {
    echo "Name Host Directory"
    echo "----- ----- ----------"
    for ((i=0; i<${#names[@]}; i++ )); do
        echo "${names[$i]} ${hosts[$i]} ${directories[$i]}"
    done 
    } | column -t

}

function clear_workspaces() {
    echo "Are you sure?"
    echo "Not implemented returning"
    return
    rm ${workspace_files}/remembered_*
    rm --preserve-root -recursive ${workspace_files}/${remove_workspace_name}
}

# move to the workspace directory
function populate_perforce_workspaces() {
    local perforce_user_name perforce_workspaces
    if [ -n "${1}" ]; then
        perforce_user_name = ${1}
    else
        perforce_user_name = ${USER}
    fi

    perforce_workspaces = p4 workspaces -u ${perforce_user_name}
    workspace_names = ${perforce_workspaces} # 2nd column
    workspace_directories = ${perforce_workspaces} # 5th column

    # TODO: insert the workspaces listed in the above

}

# detect what the current workspace is from the pwd
function detect_workspace() {
    echo "not implemented yet"
    echo ${PWD}

}


# jumping to specific files in workspaces

last_remembered=
function remember() {
    if [ -n "${1}" ]; then
        directory_name=${1}
    else
        directory_name=${PWD##*/}
    fi

    echo "Remembering ${PWD} as ${directory_name}"

    if [ -n "${current_workspace}" ]; then
        echo "${directory_name} ${PWD}" >> ${workspace_files}/${current_workspace_name}/remembered_files
    fi
    echo "${current_workspace} (directory_name|${PWD})" >> ${workspace_files}/remembered_files

    #awk '/${HOSTNAME}/' '{ $directory_name }'
    #echo ${HOSTNAME} ${directory_name} >> ${workspace_files}/remembered_hosts

}

last_jumped="root"
function jump() {
    if [ -n "$1" ]; then 
        jump_name=${1}
    else
        jump_name=${last_jumped}
    fi

    if [ -n "${current_workspace_name}" ]; then
        remembered_file=$(egrep "^${jump_name} " ${workspace_files}/${current_workspace_name}/remembered_files | awk '{ print $2 }' )
        if [ -n "${remembered_file}" ]; then
            echo "Jumping to ${remembered_file}"
            cd ${remembered_file}
        else
cat << EOF
This is not a file you've remembered.
Use "remember [name]" to remember a file with an associated name.
EOF
        fi

    else
cat << EOF
You are not currently in a workspace
Jumping outside a workspace is currently unsupported
EOF
    fi
}

# add tab completion
_jump() {
    COMPREPLY=( $(compgen -W "$(awk '{ print $1 }' < ${workspace_files}/${current_workspace_name}/remembered_files)" "${COMP_WORDS[COMP_CWORD]}") )
}
complete -F _jump jump

function forget() {
    echo "Not currently supported."
    return
    perl -i -pe "s#`pwd`##" ${workspace_files}/remembered_files
}

function list_memories() {
    
    local names directories
    names=($(awk '{ print $1 }' < ${workspace_files}/${current_workspace_name}/remembered_files))
    directories=($(awk '{ print $2 }' < ${workspace_files}/${current_workspace_name}/remembered_files))

    {
    echo "Name Directory"
    for ((i=0; i<${#names[@]}; i++ )); do
        echo ${names[$i]} ${directories[$i]}
    done 
    } | column -t
}

