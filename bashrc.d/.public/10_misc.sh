
# From http://stackoverflow.com/questions/370047/#370255
function path_remove() {
  IFS=:
  # convert it to an array
  t=($PATH)
  unset IFS
  # perform any array operations to remove elements from the array
  t=(${t[@]%%$1})
  IFS=:
  # output the new array
  echo "${t[*]}"
}

# Check the window size after each command
shopt -s checkwinsize

# fix's slight spelling mistakes in cd commands
shopt -s cdspell

# attempt to perform hostname completion
shopt -s hostcomplete

export GREP_OPTIONS='--color=auto'
#export GREP_COLORS

# Prevent less from clearing the screen while still showing colors.
export LESS=-XR

# Set the terminal's title bar.
function titlebar() {
  echo -n $'\e]0;'"$*"$'\a'
}

