# Modified from a prompt written by Ben Alman

# default_shell prompt
export PS1="\[\e[1;34m\][\A]\[\e[0m\] \h \w$ "
export PS2="| "

#information_color=$(eval \$$prompt_colors[0])
#bracket_color=$(eval \$$prompt_colors[1])
#error_color=$(eval \$$prompt_colors[2])
#clock_color=$(eval \$$prompt_colors[3])
#terminator_color=$(eval \$$prompt_colors[4])

#if [[ ! "${prompt_colors[@]}" ]]; then
  prompt_colors=(
    "${White}" # information color
    "${BWhite}" # bracket color
    "${Red}"  # error color
    "${Red}"  # clock color

  )
#fi
  prompt_terminator="$"

# special situations
#if [[ "$SSH_TTY" ]]; then
#    _connected_via_ssh
#elif [[ "$USER" == "root" ]]; then
#    _logged_in_as_root
#fi
#
#function _check_writability() {
#  if [ ! -w "." ]; then
#    _in_read_only_directory
#  else
#    _in_writable_directory
#  fi
#}


save_cursor="\[\033[s\]"
load_cursor="\[\033[u\]"

# Inside a prompt function, run this alias to setup local $c0-$c9 color vars.
alias prompt_getcolors='prompt_colors[9]=; local i; for i in ${!prompt_colors[@]}; do local c$i="${prompt_colors[$i]}"; done'

# put something in  the upper right of the terminal
# prototype
function upper_right() {
  prompt_getcolors
  if [ -n "$1" ]; then
      t=$(echo -e $1)
      echo -e $1
    echo "${save_cursor}\[\033[1;\$((COLUMNS-${#t}))f\]$1${load_cursor}"
  fi
}

# Exit code of previous command.
function prompt_exitcode() {
  prompt_getcolors
  [[ $1 != 0 ]] && echo "$c2$1$c9"
}

function prompt_clock() {
  prompt_getcolors
  if [ ! -w "." ]; then
    c4=${BRed}
  else
    c4=${BBlue}
  fi

  echo "$c1[$c4$(date +"%H$c1:$c4%M$c1")$c1]$c9"
}

function present_working_directory() {
    # options:
    # type of highlighting
    # highlight the workspace name
    # highlight the workspace path
    #if [ ! -z "${current_workspace_name}" && `expr index "${PWD}" "${current_workspace_name}"` > 1 ]; then
    #    echo "${PWD%${current_workspace_name}*}\
    #    ${White}${current_workspace_name}\
    #    ${BWhite}${PWD#*${current_workspace_name}}"
    #fi
    echo "not yet implemented"
}

function basic_prompt() {
    PS1="$(prompt_clock) \h \w${prompt_terminator} "
}


# Git status.
function prompt_git() {
  prompt_getcolors
  local status output flags
  status="$(git status 2>/dev/null)"
  [[ $? != 0 ]] && return;
  output="$(echo "$status" | awk '/# Initial commit/ {print "(init)"}')"
  [[ "$output" ]] || output="$(echo "$status" | awk '/# On branch/ {print $4}')"
  [[ "$output" ]] || output="$(git branch | perl -ne '/^\* (.*)/ && print $1')"
  flags="$(
    echo "$status" | awk 'BEGIN {r=""} \
      /^# Changes to be committed:$/        {r=r "+"}\
      /^# Changes not staged for commit:$/  {r=r "!"}\
      /^# Untracked files:$/                {r=r "?"}\
      END {print r}'
  )"
  if [[ "$flags" ]]; then
    output="$output$c1:$c0$flags"
  fi
  echo "$c1[$c0$output$c1]$c9"
}

# SVN info.
function prompt_svn() {
  prompt_getcolors
  local info="$(svn info . 2> /dev/null)"
  local last current
  if [[ "$info" ]]; then
    last="$(echo "$info" | awk '/Last Changed Rev:/ {print $4}')"
    current="$(echo "$info" | awk '/Revision:/ {print $2}')"
    echo "$c1[$c0$last$c1:$c0$current$c1]$c9"
  fi
}

# Maintain a per-execution call stack.
prompt_stack=()
trap 'prompt_stack=("${prompt_stack[@]}" "$BASH_COMMAND")' DEBUG

function prompt_command() {
  local exit_code=$?
  # If the first command in the stack is prompt_command, no command was run.
  # Set exit_code to 0 and reset the stack.
  [[ "${prompt_stack[0]}" == "prompt_command" ]] && exit_code=0
  prompt_stack=()

  # Manually load z here, after $? is checked, to keep $? from being clobbered.
  #[[ "$(type -t _z)" ]] && _z --add "$(pwd -P 2>/dev/null)" 2>/dev/null

  # While the simple_prompt environment var is set, disable the awesome prompt.
  [[ "$simple_prompt" ]] && PS1='\n$ ' && return

  prompt_getcolors

  PS1="\n"
  repository_data=""
  # svn: [repo:lastchanged]
  #repository_data="${repository_data}$(prompt_svn)"
  # git: [branch:flags]
  #repository_data="${repository_data}$(prompt_git)"
  # perforce: flags
  repository_data="${repository_data}$(prompt_perforce)"

  # path: [user@host:path]
  # date: [HH:MM]
  PS1="$PS1$(prompt_clock) "
  PS1="$PS1${repository_data}"
  PS1="$PS1$c1[$c0\u$c1@$c0\h$c1:$c0\w$c1]$c9 "

  # exit code: 127
  #PS1="$PS1$(prompt_exitcode "$exit_code")$c9"

  #PS1="$PS1$(_upper_right "${repository_data}")"

  # end of the prompt
  PS1="$PS1${prompt_terminator} $c0"
}

# the default prompt command
PROMPT_COMMAND=basic_prompt # this essentially overwrites PS1

# switch between different prompts
function switch_prompt() {
    if [ "$1" == "basic" ]; then
        PROMPT_COMMAND=basic_prompt;
    elif [ "$1" == "experimental" ]; then
        PROMPT_COMMAND=prompt_command;
    fi
}

