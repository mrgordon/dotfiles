eval "$(rbenv init -)"

alias hps='ps -e -o pid,command'
alias e='emacs'

export SSL_CERT_FILE=~/.cacert.pem
export EDITOR=emacs
# number of lines kept in history
export HISTSIZE=100000
# number of lines saved in the history after logout
export SAVEHIST=100000
# location of history
export HISTFILE=~/.zhistory
# append command to history file once executed
setopt inc_append_history


# Tab completion
autoload -U compinit
compinit
# Cache the tab completions
zstyle ':completion::complete:*' use-cache 1

# Make Mac delete key work properly
bindkey '^[[3~' delete-char

# Make stderr red
exec 2>>(while read line; do
  print '\e[91m'${(q)line}'\e[0m' > /dev/tty; print -n $'\0'; done &)

# The sequence C-s is normally taken from the terminal driver
# To free up the sequence for use by readline, we set the stop terminal
# sequence to some other sequence
stty stop ^J

# Display current directory in terminal title bar
chpwd() {
  [[ -o interactive ]] || return
  case $TERM in
    sun-cmd) print -Pn "\e]l%~\e\\"
      ;;
    *xterm*|rxvt|(dt|k|E)term) print -Pn "\e]2;%~\a"
      ;;
  esac
}

# Put git project and branch into prompt if in a repo
git_prompt_info() {
    BRANCH=$(git symbolic-ref HEAD 2> /dev/null)
    if [[ -n $BRANCH ]]; then
	BRANCH_NAME=$(echo $BRANCH | cut -d '/' -f3-)
	echo " $BRANCH_NAME"
    fi
}
get_git_dirty() {
    BRANCH=$(git symbolic-ref HEAD 2> /dev/null)
    if [[ -n $BRANCH ]]; then
	git diff --quiet 2> /dev/null || echo '*'
    fi
}
autoload -U colors
colors
setopt prompt_subst
PROMPT='%{$fg[blue]%}%c%{$fg_bold[red]%}$(git_prompt_info)$(get_git_dirty)%{$fg[blue]%} $ %{$reset_color%}'
RPROMPT='%{$fg[green]%}%1(j.%j.)'
