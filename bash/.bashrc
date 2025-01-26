# ===== Verificación de Shell Interactivo =====
[[ $- != *i* ]] && return

# ===== Información del Sistema =====
if command -v fastfetch >/dev/null; then
    if [[ -z "$TMUX" ]] && tty | grep -q "/dev/tty[0-9]"; then
        clear
        fastfetch --config examples/20 2>/dev/null
    elif [[ "$TERM" != "linux" ]] && [[ -z "$TMUX" ]]; then
        fastfetch --config examples/8 2>/dev/null
    fi
fi

# ===== Configuración Básica =====
export EDITOR="vim"
export VISUAL="$EDITOR"

alias sudo='sudo -E'
export SUDO_PROMPT=$'\e[36m󰒃 \e[1m[sudo]\e[0m \e[36mContraseña:\e[0m '
# ===== Configuraciones de Seguridad =====
umask 027
export HISTCONTROL="ignoreboth:erasedups"
export HISTIGNORE="ls:ll:pwd:exit:cd:cd -:cd ..:rm*:clear:history:h:bg:fg:jobs"

# ===== Gestión de Historial Mejorada =====
export HISTSIZE=1000000
export HISTFILESIZE=2000000
export HISTTIMEFORMAT="[%F %T] "
export HISTFILE="$HOME/.bash_history"
shopt -s histappend cmdhist lithist

PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"

# ===== Opciones del Shell =====
shopt -s autocd cdspell direxpand dirspell globstar nocaseglob checkwinsize

# ===== Configuración Avanzada de FZF =====
if command -v fzf >/dev/null; then
    # Comandos de búsqueda mejorados
    search_cmd="fd --type f --hidden --follow --exclude .git 2>/dev/null"
    dir_cmd="fd --type d --hidden --follow --exclude .git 2>/dev/null"

    export FZF_DEFAULT_COMMAND="$search_cmd"
    export FZF_CTRL_T_COMMAND="$search_cmd"
    export FZF_ALT_C_COMMAND="$dir_cmd"

    # Configuración de preview dinámica
    preview_cmd='bat --style=numbers --color=always {} 2>/dev/null || eza -T -L 2 --color=always {} 2>/dev/null || ls -la --color=always {} 2>/dev/null'

    export FZF_DEFAULT_OPTS="
        --height 60%
        --layout=reverse
        --border sharp
        --preview-window=hidden
        --pointer='▶'
        --marker='✓'
        --color=dark
        --color='fg:#9EACAD,fg+:#EEE8D5,bg:#00141A,bg+:#002B36'
        --color='info:#6C71C4,prompt:#268BD2,pointer:#B58900'
        --color='marker:#B58900,spinner:#2AA198,header:#268BD2'
        --bind 'ctrl-/:toggle-preview'
        --bind 'ctrl-space:toggle-preview'
        --bind 'ctrl-y:execute-silent(echo -n {} | xsel -ib)+abort'
        --bind 'ctrl-e:execute($EDITOR {})+abort'
        --bind 'ctrl-f:preview-page-down'
        --bind 'ctrl-b:preview-page-up'
        --bind 'alt-j:preview-down'
        --bind 'alt-k:preview-up'
        --bind 'ctrl-a:select-all'
        --bind 'ctrl-d:deselect-all'
        --preview '$preview_cmd || echo {} | head -200'"

    # Carga de key-bindings adicionales
    [[ -f /usr/share/fzf/key-bindings.bash ]] && source /usr/share/fzf/key-bindings.bash
fi

# ===== Herramientas Externas =====
# Bat para manuales
command -v bat >/dev/null && export MANPAGER="sh -c 'col -bx | bat -l man -p --theme=default'"

# Zoxide (cd inteligente)
command -v zoxide >/dev/null && eval "$(zoxide init bash --hook prompt)"

# Starship Prompt (carga optimizada)
if command -v starship >/dev/null; then
    export STARSHIP_CONFIG="$HOME/.config/starship.toml"
    eval "$(starship init bash --print-full-init | grep -v 'set -o promptpmptpmt')"
fi

# Carapace (autocompletado avanzado)
command -v carapace >/dev/null && source <(carapace _carapace)

# ===== Carga de Configuraciones Adicionales =====
[[ -f ~/.aliases ]] && source ~/.aliases
[[ -f ~/.functions ]] && source ~/.functions

# ===== Limpieza Final =====
unset preview_cmd search_cmd dir_cmd
