dotfiles
========

These are the dotfiles that I use

Directory Structure
-------------------

.files
 |- bashrc.d            - files that should be sourced when a new bash is started 
 `|- .public            - files that should be shared on github
  |- .local             - files that should not be shared because of machine specific settings
 |- global              - should be sourced to get the locations of the other dotfiles
 |- link                - files that should be linked to the ~ directory
 `|-oh-my-zsh           - manages zsh plugins
  |-vim                 - contains vundle and manages vim plugins
 |- install             - contains packages to be installed on the users machine
 |- scripts             - executable scripts

basrc.d
-------

100_aliases.sh
    cd cd <dir>         - fixes double cd mistake
    cdls <dir>          - does cd ls in a directory
    mgrind              - find all makefiles and grep them
    cgrind              - find all cmakefiles and grep them
    cscope_source       - look for a cscope.out file to source
    cscope_generate     - generate a cscope.files
    bd                  - go backwards through folders looking for the requested directory
    extract             - extracts files based on the extension

100_bash_completion.sh  - sources bash completion stuff
100_colors.sh           - sets colors for easier use
100_powerline.sh        - sources powerline
100_z.sh                - sources z 
110_misc.sh             - whatever doesn't go into the other files
110_workspace.sh        - easy moving between workspaces
    add_workspace       - adds a workspace to the list of tracked workspaces
    switch_workspace    - aka ws switches between tracked workspaces
    remove_workspace    - removes a workspace from the list of tracked workspaces
    list_workspace      - lists all of the workspaces
    clear_workspace     - removes all information about all workspaces
    detect_workspace
    remember            - remembers a folder in a workspace
    jump                - jumps to a remembered folder in a workspace
    forget              - forgets a remembered folder
    list_memories       - lists the remembered folder

150_history.sh          - aliases and variables associated with history
150_prompt.sh           - custom prompt set up
    prompt_exitcode
    prompt_clock        - shows a clock
    prompt_git          - shows the state of a git repository
    prompt_svn          - shows the state of a svn repository
    basic_prompt        - a simple prompt that does not show repo information
    complex_prompt      - a prompt that will show repo information
    switch_prompt       - switch between different prompts

scripts
-------
This directory should be pointed to by path
