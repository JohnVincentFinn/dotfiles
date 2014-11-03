
if_verbose echo "themes is being sourced"

# if the current theme isn't linked properly make it the default
if [ ! -e "${current_theme_directory}" ]; then
    if [ -e "${default_theme_directory}" ]; then
        ln --symbolic ${default_theme_directory} ${current_theme_directory}
    fi
fi

# set up some colours if a theme directory is found
if [ -e "${current_theme_directory}" ]; then
    eval $(dircolors ${current_theme_directory}/dircolors.theme)
fi

function switch_theme() {

    # no argument could mean default but chances are it's a mistake
    if [ -z "${1}" ]; then
        echo "no theme was specified"
        echo "to switch to the default theme use \"default\""
    fi
    theme_name=${1}

    if [ ! -e "${theme_directory}/${theme_name}" ]; then
        echo "no theme by that name exists"
    fi

    # make sure we actually have a place to put it
    if [ -z "${current_theme_directory}" ]; then
        echo "~/.files/global must have been screwed up"
        echo "\${current_theme_directory} isn't set"
        return
    fi
    if [ -e "${current_theme_directory}" ]; then
        rm ${current_theme_directory}
    fi
    ln --symbolic ${theme_directory}/${theme_name} ${current_theme_directory}

    # now re-source everything
    eval $(dircolors ${current_theme_directory}/dircolors.theme)
    tmux source-file ${current_theme_directory}/tmux.theme > /dev/null

    # vim doesn't need to be resourced just reopen it

    #these ones will have to wait
    xrdb -merge ${current_theme_directory}/Xresources.theme
    #echo 'awesome.restart()' | awesome-client
}

# write tab completion for switch_theme it should be pretty easy
function _switch_theme() {
    echo "not implemented"
}

