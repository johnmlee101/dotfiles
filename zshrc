#
# Executes commands at the start of an interactive session.
#

# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

export TERM=xterm-256color
export HISTSIZE=100000000

setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing non-existent history.

# Make Ctrl-z also resume background process
fancy-ctrl-z () {
    if [[ $#BUFFER -eq 0 ]]; then
          BUFFER="fg"
              zle accept-line
                else
                      zleush-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# load Z: https://github.com/rupa/z
. ~/.dotfiles/z.sh

source ~/.aliases
source ~/.local_shellrc


push(){
	branch=`git rev-parse --abbrev-ref HEAD`
	if [ $branch '==' 'master' ]; then
		echo "DO NOT PUSH TO MASTER"
	else
		git push origin $branch
	fi
}

pr(){
    remote=`git remote -v | grep origin | head -1 | awk '{print $2}' | sed 's/.*:\(.*\)*/\1/' | sed 's/\.git$//'`
	branch=`git rev-parse --abbrev-ref HEAD`
	open "https://github.com/$remote/compare/${1:-master}...$branch?expand=1"
}

export PATH=$PATH:~/bin
