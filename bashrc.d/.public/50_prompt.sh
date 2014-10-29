# Modified from a prompt written by Ben Alman

# default_shell prompt
export PS1="\[\e[1;34m\][\A]\[\e[0m\] \h \w$ "
export PS2="| "

#if [[ ! "${prompt_colors[@]}" ]]; then
  prompt_colors=(
    "${White}"  # information color
    "${BWhite}" # bracket color
    "${Red}"    # error color
    "${Red}"    # clock color

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


# Inside a prompt function, run this alias to setup local $c0-$c9 color vars.
alias prompt_getcolors='prompt_colors[9]=; local i; for i in ${!prompt_colors[@]}; do local c$i="${prompt_colors[$i]}"; done'

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

function basic_prompt() {
    prompt_getcolors
    PS1="$(prompt_clock) \h \w${prompt_terminator} "
}

function complex_prompt() {
  prompt_getcolors
  local exit_code=$?

  # Manually load z here, after $? is checked, to keep $? from being clobbered.
  #[[ "$(type -t _z)" ]] && _z --add "$(pwd -P 2>/dev/null)" 2>/dev/null


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

  # end of the prompt
  PS1="$PS1${prompt_terminator} $c0"
}

# the default prompt command
PROMPT_COMMAND=basic_prompt # this essentially overwrites PS1

# switch between different prompts
function switch_prompt() {
    if [ "$1" == "basic" ]; then
        PROMPT_COMMAND=basic_prompt;
    elif [ "$1" == "complex" ]; then
        PROMPT_COMMAND=complex_prompt;
    fi
}


