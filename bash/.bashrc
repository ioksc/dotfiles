# Editor configuration
export EDITOR=vim
export VISUAL="${EDITOR}"

# History configuration
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="ls:pwd:exit:cd -:cd ..:rm"
export HISTFILE=~/.zhistory

# Improve security
umask 027

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Shell options
shopt -s histappend checkwinsize cmdhist autocd cdspell

# # External tools: starship, fzf, zoxide
command -v starship &> /dev/null && eval "$(starship init bash)"
command -v fzf &> /dev/null && eval "$(fzf --bash)"
command -v zoxide &> /dev/null && eval "$(zoxide init bash)"

# check if .aliases file exists and source it
[[ -f ~/.aliases ]] && source ~/.aliases

# check if .functions file exists and source it
[[ -f ~/.functions ]] && source ~/.functions

