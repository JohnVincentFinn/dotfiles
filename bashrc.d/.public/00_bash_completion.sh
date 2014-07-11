
#source ~/.files/bashrc.d/.bash_completion/bash_completion

# SSH auto-completion based on entries in known_hosts.
if [[ -e ~/.ssh/known_hosts ]]; then
  complete -o default -W "$(cat ~/.ssh/known_hosts | sed 's/[, ].*//' | sort | uniq)" ssh scp sftp
fi

