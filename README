dotfiles
========
</br>
These are the dotfiles that I use</br>
</br>
Directory Structure
-------------------
</br>
.files</br>
 |- bashrc.d            - files that should be sourced when a new bash is started </br>
 `|- .public            - files that should be shared on github</br>
  |- .local             - files that should not be shared because of machine specific settings</br>
 |- global              - should be sourced to get the locations of the other dotfiles</br>
 |- link                - files that should be linked to the ~ directory</br>
 `|-oh-my-zsh           - manages zsh plugins</br>
  |-vim                 - contains vundle and manages vim plugins</br>
 |- install             - contains packages to be installed on the users machine</br>
 |- scripts             - executable scripts</br>
</br>
basrc.d
-------
</br>
100_aliases.sh</br>
    cd cd <dir>         - fixes double cd mistake</br>
    cdls <dir>          - does cd ls in a directory</br>
    mgrind              - find all makefiles and grep them</br>
    cgrind              - find all cmakefiles and grep them</br>
    cscope_source       - look for a cscope.out file to source</br>
    cscope_generate     - generate a cscope.files</br>
    bd                  - go backwards through folders looking for the requested directory</br>
    extract             - extracts files based on the extension</br>
</br>
100_bash_completion.sh  - sources bash completion stuff</br>
100_colors.sh           - sets colors for easier use</br>
100_powerline.sh        - sources powerline</br>
100_z.sh                - sources z </br>
110_misc.sh             - whatever doesn't go into the other files</br>
110_workspace.sh        - easy moving between workspaces</br>
    add_workspace       - adds a workspace to the list of tracked workspaces</br>
    switch_workspace    - aka ws switches between tracked workspaces</br>
    remove_workspace    - removes a workspace from the list of tracked workspaces</br>
    list_workspace      - lists all of the workspaces</br>
    clear_workspace     - removes all information about all workspaces</br>
    detect_workspace</br>
    remember            - remembers a folder in a workspace</br>
    jump                - jumps to a remembered folder in a workspace</br>
    forget              - forgets a remembered folder</br>
    list_memories       - lists the remembered folder</br>
</br>
150_history.sh          - aliases and variables associated with history</br>
150_prompt.sh           - custom prompt set up</br>
    prompt_exitcode</br>
    prompt_clock        - shows a clock</br>
    prompt_git          - shows the state of a git repository</br>
    prompt_svn          - shows the state of a svn repository</br>
    basic_prompt        - a simple prompt that does not show repo information</br>
    complex_prompt      - a prompt that will show repo information</br>
    switch_prompt       - switch between different prompts</br>
</br>
scripts
-------
contains configure.files which should be run on new syncs (when it's done)</br>
This directory should be pointed to by path</br>
