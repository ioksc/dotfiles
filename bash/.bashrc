# ~/.bashrc - Optimizado

# Salir si no es interactivo
[[ $- != *i* ]] && return

# ===== Variables de entorno =====
export EDITOR="vim"
export VISUAL="vim"
export TERMINAL="alacritty"
export BROWSER="firefox"
export MANPAGER="sh -c 'col -bx | bat -l man -p --theme=Dracula'"
export BAT_PAGER="less -RF"
export MANROFFOPT="-P -c"
export COLORTERM=truecolor
export _JAVA_AWT_WM_NONREPARENTING=1

CLOUDFLARE_API_TOKEN="$(<~/.cloudflare_token)" || true
export CLOUDFLARE_API_TOKEN

_NCORE=$(nproc)
export PLATFORMIO_RUN_JOBS=$_NCORE
export CARGO_BUILD_JOBS=$_NCORE
unset _NCORE

_add_to_path() {
  [[ -d "$1" ]] && PATH="$1:$PATH"
}
_add_to_path "$HOME/.local/bin"
_add_to_path "$HOME/.cargo/bin"
_add_to_path "$HOME/go/bin"
_add_to_path "$HOME/.local/share/fnm"
unset _add_to_path

# ===== Historial =====
export HISTCONTROL="ignoreboth:erasedups"
export HISTIGNORE="ls:ll:la:pwd:exit:cd:cd -:cd ..:rm *:clear:history:h:bg:fg:jobs"
export HISTSIZE=100000
export HISTFILESIZE=200000
export HISTTIMEFORMAT="%F %T "

# ===== Terminal y color =====
export TERM=xterm-256color
if [[ -n "$TMUX" ]]; then
  export TERM=tmux-256color
fi

# ===== Shell options =====
shopt -s autocd cdspell direxpand dirspell globstar nocaseglob checkwinsize \
  histappend cmdhist lithist histverify

# Permisos por defecto (archivos 640, directorios 750)
umask 0027
# umask 0022

# ===== Función Helper para Comandos =====
_has() {
  [[ -x "$(command -v "$1" 2>/dev/null)" ]]
}

# Starship prompt
if _has starship; then
  eval "$(starship init bash)"
fi

# Zoxide - Navegación inteligente
if _has zoxide; then
  eval "$(zoxide init bash)"
fi

# ===== FZF - Fuzzy finder =====
if _has fzf; then
  _FZF_CMD="fd --type f --hidden --follow --exclude .git --exclude node_modules"
  export FZF_DEFAULT_COMMAND="$_FZF_CMD"
  export FZF_CTRL_T_COMMAND="$_FZF_CMD"
  export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git --exclude node_modules"
  export FZF_DEFAULT_OPTS="--height 60% --layout=reverse --border sharp --preview-window=hidden --pointer='▶' --marker='✓' --color='fg:#D4D4D4,fg+:#FFFFFF,bg:#1E1E2E,bg+:#313244,info:#CBA6F7,prompt:#89B4FA,pointer:#F9E2AF,marker:#A6E3A1,spinner:#94E2D5,header:#F38BA8' --bind 'ctrl-/:toggle-preview,ctrl-space:toggle-preview' --bind 'ctrl-y:execute-silent(echo -n {} | xsel -ib)+abort' --bind 'ctrl-e:execute(\$EDITOR {})+abort' --bind 'ctrl-f:preview-page-down,ctrl-b:preview-page-up' --bind 'alt-j:preview-down,alt-k:preview-up' --bind 'ctrl-a:select-all,ctrl-d:deselect-all' --preview '[[ -f {} ]] && bat --style=numbers --color=always {} || eza -T -L 2 --color=always {} || ls -la --color=always {}'"

  [[ -f /usr/share/fzf/key-bindings.bash ]] && source /usr/share/fzf/key-bindings.bash
  [[ -f /usr/share/fzf/completion.bash ]] && source /usr/share/fzf/completion.bash
  unset _FZF_CMD
fi

# ===== Herramientas de Desarrollo =====

# fnm - Node version manager
if [[ -d "$HOME/.local/share/fnm" ]]; then
  eval "$(fnm env --use-on-cd --shell bash)"
fi

# Cargo/Rust
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# Carapace - Completions
_has carapace && source <(carapace _carapace bash)

# ===== Herramientas Opcionales =====

# Broot
[[ -f "$HOME/.config/broot/launcher/bash/br" ]] && source "$HOME/.config/broot/launcher/bash/br"

# Pywal - Colores del terminal
[[ -f ~/.cache/wal/sequences ]] && cat ~/.cache/wal/sequences
# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
# Archivos modulares

[[ -f ~/.aliases ]] && source ~/.aliases
[[ -f ~/.functions ]] && source ~/.functions

# ===== Configuración Final =====

# PROMPT_COMMAND optimizado para Starship
_setup_prompt_command() {
  local hist_cmd="history -a; history -n"
  if [[ "$PROMPT_COMMAND" == *"starship_precmd"* ]]; then
    PROMPT_COMMAND="$hist_cmd; ${PROMPT_COMMAND#"${hist_cmd}; "}"
  else
    PROMPT_COMMAND="$hist_cmd"
  fi
}
_setup_prompt_command
