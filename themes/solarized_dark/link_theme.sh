
awesome_theme_directory=~/.config/awesome/themes
dircolors_theme_directory=~/.files/install/dircolors-solarized
tmux_theme_directory=~/.files/install/solarized/tmux
vim_theme_directory=~/.vim/vim.d
xresources_theme_directory=~/.files/install/solarized/xresources

awesome_theme_name=grey
dircolors_theme_name=dircolors.ansi-dark
tmux_theme_name=tmuxcolors-dark.conf
vim_theme_name=solarized_dark
xresources_theme_name=solarized

theme_files=("awesome" "dircolors" "tmux" "vim xresources")
#ln --symbolic awesome.theme     ${awesome_theme_directory}/${awesome_theme_name}
#ln --symbolic dircolors.theme
#ln --symbolic tmux.theme
#ln --symbolic vim.theme
#ln --symbolic xresources.theme

function link_theme() {
    for theme_file in ${theme_files[@]}; do
        theme_directory=${theme_file}_theme_directory
        theme_name=${theme_file}_theme_name
        [[ $1 == "-v" ]] && echo "linking ${theme_file}.theme to ${!theme_directory}/${!theme_name}"
        ln --symbolic ${!theme_directory}/${!theme_name} ${theme_file}.theme
    done
}

link_theme $@

