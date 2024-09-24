# Editor configuration
export EDITOR=vim
export VISUAL="${EDITOR}"

# fzf configuration
export FZF_DEFAULT_OPTS="
    --height 40%
    --layout=reverse
    --border
    --info=inline
    --multi
    --preview-window=right:50%:hidden
    --preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
    --color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
    --prompt='❯ ' --pointer='▶' --marker='✓'
    --bind '?:toggle-preview'
    --bind 'ctrl-a:select-all'
    --bind 'ctrl-y:execute-silent(echo {+} | xclip -selection clipboard)'
    --bind 'ctrl-e:execute(echo {+} | xargs -o $EDITOR)'
    --bind 'ctrl-v:execute(code {+})'"

export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"

# History configuration
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="ls:pwd:exit:cd -:cd ..:rm*:clear"
export HISTFILE=~/.bash_history

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

if [ -z "$TMUX" ]; then
    fastfetch --config examples/8
fi

# fnm
FNM_PATH="${HOME}/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
fi
