
[[ $- != *i* ]] && return # Si no se está ejecutando de forma interactiva, no hacer nada

# ===== Información del Sistema =====
if command -v fastfetch >/dev/null; then
    if [ -z "$TMUX" ]; then
        if tty | grep -q "/dev/tty[0-9]"; then
            fastfetch --config examples/20 2>/dev/null
        elif [ "$TERM" != "linux" ]; then
            fastfetch --config examples/8 2>/dev/null
        fi
    fi
fi

# ===== Configuración Básica =====
# Configuración del editor
export EDITOR=vim
export VISUAL="${EDITOR}"
# export SUDO_PROMPT= 'Ingresa tu contraseña: '
export SUDO_PROMPT=$'\e[36m 󰒃 [sudo] \e[1m\033[5mIngresa tu contraseña: \e[0m'

# export TERM="xterm-256color"

# ===== Configuraciones de Seguridad Mejoradas =====
umask 027                  # Permisos de archivo restrictivos

# ===== Configuración de Historial =====
export HISTSIZE=100000
export HISTFILESIZE=200000
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="ls:ll:pwd:exit:cd -:cd ..:rm*:clear:history:h:bg:fg:jobs"
export HISTTIMEFORMAT="[%F %T] "
export HISTFILE=~/.bash_history


# Guardar y recargar el historial después de cada comando
PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"

# ===== Opciones de Shell =====
# Navegación de directorio mejorada
shopt -s autocd cdspell direxpand dirspell

# Mejoras del historial
shopt -s histappend histverify histreedit

# Coincidencia de patrones y globbing
shopt -s extglob globstar nocaseglob

# Control de trabajos y edición de línea de comandos
shopt -s checkwinsize cmdhist lithist

# ===== Configuración de FZF =====
if command -v fzf >/dev/null; then
    # Verificar herramientas de previsualización
    PREVIEW_CMD=""
    if command -v bat >/dev/null; then
        PREVIEW_CMD="bat --style=numbers --color=always {}"
    else
        PREVIEW_CMD="cat {}"
    fi

    if command -v eza >/dev/null; then
        PREVIEW_CMD="$PREVIEW_CMD || (eza -T -L 2 --color=always {})"
    else
        PREVIEW_CMD="$PREVIEW_CMD || (ls -la --color=always {})"
    fi

    export FZF_DEFAULT_OPTS="
        --height 60%
        --layout=reverse
        --border sharp
        --marker='✓'
        --pointer='▶'
        --preview-window=right:40%
        --preview '$PREVIEW_CMD || echo {} 2> /dev/null | head -200'
        --bind 'ctrl-/:toggle-preview'
        --bind 'ctrl-y:execute-silent(echo -n {} | xclip -selection clipboard)+abort'
        --bind 'ctrl-e:execute(${EDITOR:-vim} {})+abort'
        --bind 'ctrl-f:preview-page-down'
        --bind 'ctrl-b:preview-page-up'
        --bind 'alt-j:preview-down'
        --bind 'alt-k:preview-up'
        --bind 'ctrl-space:toggle-preview'
        --bind 'ctrl-a:select-all'
        --bind 'ctrl-d:deselect-all'
        --color=dark
        --color='fg:#9EACAD,fg+:#EEE8D5,bg:#00141A,bg+:#002B36'
        --color='info:#6C71C4,prompt:#268BD2,pointer:#B58900'
        --color='marker:#B58900,spinner:#2AA198,header:#268BD2'"

    # Configuración mejorada de FZF con manejo de errores
    if command -v fd >/dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    else
        export FZF_DEFAULT_COMMAND='find . -type f -not -path "*/\.git/*" 2>/dev/null'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='find . -type d -not -path "*/\.git/*" 2>/dev/null'
    fi
fi


if command -v bat >/dev/null; then
    export MANPAGER="sh -c 'col -bx | bat -l man -p --theme=default'"
    export MANROFFOPT="-c"
    export BAT_PAGER="less -RF"
    export MANROFFOPT="-P -c"
fi

# ===== Herramientas Externas =====
# Cargar alias y funciones con verificación de errores
[[ -f ~/.aliases ]] && source ~/.aliases
[[ -f ~/.functions ]] && source ~/.functions

# Bash Autocompletion
[[ -f /usr/share/bash-completion/bash_completion ]] && source /usr/share/bash-completion/bash_completion

# Inicialización de herramientas externas
eval -- "$(/sbin/starship init bash --print-full-init)"
command -v fzf &>/dev/null && eval "$(fzf --bash)"
command -v zoxide &>/dev/null && eval "$(zoxide init bash)"

# Carapace
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # opcional
source <(carapace _carapace)
