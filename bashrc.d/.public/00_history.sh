# History settings

# Allow use to re-edit a failed history substitution.
shopt -s histreedit

# Entries beginning with space aren't added into history, and duplicate
# entries will be erased (leaving the most recent entry).
export HISTCONTROL="ignorespace:erasedups"
export HISTFILE=~/.bash_history
export HISTFILESIZE=10000
export HISTSIZE=10000

