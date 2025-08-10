# ~/.bashrc - Configuración
# shellcheck shell=bash
# ===== Verificación de Shell Interactivo =====
[[ -z "$PS1" ]] && return

# ===== Entorno y Variables =====
export EDITOR="vim"
export VISUAL="$EDITOR"
export TERMINAL="alacritty"
export BROWSER="zen-browser"

# export LANG="es_ES.UTF-8"
# export LC_ALL="$LANG"

export GLOBSORT=-1


aditional_paths=(
	"$HOME/.local/bin"
	"$HOME/go/bin"
	"$HOME/.cargo/bin"
)

for p in "${aditional_paths[@]}"; do
	[[ ":$PATH:" != *":$p:"* ]] && PATH="$p:$PATH"
done

PATH=$(awk -v RS=: '!a[$0]++ {if (NR>1) printf ":"; printf "%s", $0}' <<<"$PATH")

export PATH

export CARGO_BUILD_JOBS=2 # $(nproc)  # Usa número de núcleos disponibles

export HISTCONTROL="ignoreboth:erasedups"
export HISTIGNORE="ls:ll:pwd:exit:cd:cd -:cd ..:rm *:clear:history:h:bg:fg:jobs"
export HISTSIZE=1000000
export HISTFILESIZE=2000000
export HISTFILE="$HOME/.bash_history"

# ===== Opciones del Shell =====
shopt -s autocd cdspell direxpand dirspell globstar nocaseglob checkwinsize histappend cmdhist lithist histverify
umask 0027 # Permisos restrictivos

# ===== Prompt y Starship =====
export STARSHIP_CONFIG="$HOME/.config/starship.toml"
eval "$(starship init bash)"

# Workaround aún más simple para tmux + Starship
if [[ -n "$TMUX" && -z "$_STARSHIP_TMUX_FIXED" ]]; then
	export _STARSHIP_TMUX_FIXED=1
	PS1="$(starship prompt)"
fi

# ===== FZF Avanzado =====
if command -v fzf >/dev/null; then
	export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git --exclude node_modules 2>/dev/null"
	export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
	export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git --exclude node_modules 2>/dev/null"
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
        --preview '[[ -f {} ]] && bat --style=numbers --color=always {} 2>/dev/null || eza -T -L 2 --color=always {} 2>/dev/null || ls -la --color=always {}'"
	[[ -f /usr/share/fzf/key-bindings.bash ]] && source /usr/share/fzf/key-bindings.bash
fi

# ===== Herramientas de Visualización =====
export MANPAGER="sh -c 'col -bx | bat -l man -p --theme=Dracula'"
export BAT_PAGER="less -RF"
export MANROFFOPT="-P -c"

# ===== Completado y Herramientas =====
command -v carapace >/dev/null && source <(carapace _carapace bash)
eval "$(uv generate-shell-completion bash)"

# ===== Configuraciones Personalizadas =====
custom_files=(
	"$HOME/.aliases"
	"$HOME/.functions"
)
for file in "${custom_files[@]}"; do
	[[ -f "$file" ]] && source "$file"
done

# ===== Temas y Colores (wal) =====
if [[ -f ~/.cache/wal/colors-tty.sh ]]; then
	source "$HOME/.cache/wal/colors-tty.sh"
fi
if [[ -f ~/.cache/wal/sequences ]] && [[ -z "$VIM" ]] && [[ -z "$NVIM" ]] && [[ -z "$TMUX" ]] && [[ -z "$CLIFM" ]]; then
	cat ~/.cache/wal/sequences
fi

unset p file

# ===== Prompt Command =====
PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND:-:}"

eval "$(zoxide init bash)"
