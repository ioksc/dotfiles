# ===== Verificación de Shell Interactivo =====
[[ $- != *i* ]] && return

# ===== Inicialización Rápida del Sistema =====
if command -v fastfetch >/dev/null && [[ -z "$TMUX" ]]; then
    case $(tty) in
        /dev/tty[0-9]*) clear; fastfetch --config examples/20 2>/dev/null ;;
        *) [[ "$TERM" != "linux" ]] && fastfetch --config examples/15 2>/dev/null ;;
    esac
fi
# ===== Entorno Básico =====
export EDITOR="vim"
export VISUAL="$EDITOR"
export PATH="$HOME/.local/bin:$PATH"  # Añade binarios locales
export TERMINAL="alacritty"
export BROWSER="firefox"

alias sudo='sudo -E'  # Preserva variables de entorno
export SUDO_PROMPT=$'\e[36m󰒃 [sudo]\e[1m contraseña:\e[0m '

# ===== Seguridad y Privacidad =====
umask 027  # Permisos más restrictivos por defecto
export HISTCONTROL="ignoreboth:erasedups"
export HISTIGNORE="ls:ll:pwd:exit:cd:cd -:cd ..:rm*:clear:history:h:bg:fg:jobs"

# ===== Historial Optimizado =====
export HISTSIZE=1000000
export HISTFILESIZE=2000000
export HISTTIMEFORMAT="[%F %T] "
export HISTFILE="$HOME/.bash_history"
shopt -s histappend cmdhist lithist  # Sincronización y formato avanzado
PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND:-:}"

# ===== Opciones del Shell =====
shopt -s autocd cdspell direxpand dirspell globstar nocaseglob checkwinsize

# ===== FZF Avanzado =====
if command -v fzf >/dev/null; then
    search_cmd="fd --type f --hidden --follow --exclude .git --exclude node_modules 2>/dev/null"
    dir_cmd="fd --type d --hidden --follow --exclude .git --exclude node_modules 2>/dev/null"

    export FZF_DEFAULT_COMMAND="$search_cmd"
    export FZF_CTRL_T_COMMAND="$search_cmd"
    export FZF_ALT_C_COMMAND="$dir_cmd"

    preview_cmd='[[ -f {} ]] && bat --style=numbers --color=always {} 2>/dev/null || eza -T -L 2 --color=always {} 2>/dev/null || ls -la --color=always {}'

    export FZF_DEFAULT_OPTS="
        --height 60% --layout=reverse --border sharp
        --preview-window=hidden --pointer='▶' --marker='✓'
        --color='fg:#D4D4D4,fg+:#FFFFFF,bg:#1E1E2E,bg+:#313244'
        --color='info:#CBA6F7,prompt:#89B4FA,pointer:#F9E2AF'
        --color='marker:#A6E3A1,spinner:#94E2D5,header:#F38BA8'
        --bind 'ctrl-/:toggle-preview,ctrl-space:toggle-preview'
        --bind 'ctrl-y:execute-silent(echo -n {} | xsel -ib)+abort'
        --bind 'ctrl-e:execute($EDITOR {})+abort'
        --bind 'ctrl-f:preview-page-down,ctrl-b:preview-page-up'
        --bind 'alt-j:preview-down,alt-k:preview-up'
        --bind 'ctrl-a:select-all,ctrl-d:deselect-all'
        --preview '$preview_cmd || echo {} | head -200'"

    [[ -f /usr/share/fzf/key-bindings.bash ]] && source /usr/share/fzf/key-bindings.bash
fi

# ===== Herramientas de Visualización =====
export MANPAGER="sh -c 'col -bx | bat -l man -p --theme=Dracula'" # Visualización de manpages
export BAT_PAGER="less -RF"
export MANROFFOPT="-P -c"

# ===== Integración de Herramientas Modernas =====
if command -v starship >/dev/null; then
    export STARSHIP_CONFIG="$HOME/.config/starship.toml"
    eval "$(starship init bash)"
fi
command -v carapace >/dev/null && source <(carapace _carapace bash)

# ===== Carga de Configuraciones Personalizadas =====
for file in ~/.aliases ~/.functions; do
    [[ -f "$file" ]] && source "$file"
done

# ===== Limpieza =====
unset preview_cmd search_cmd dir_cmd

eval "$(uv generate-shell-completion bash)"

eval "$(zoxide init bash)"
