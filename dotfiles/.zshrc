# =======================================================
# ~/.zshrc — чистый/snap/yazi/293/yazi, минималистичный, Starship + Antidote
# =======================================================

export YAZI_CONFIG_HOME="$HOME/.config/yazi"

# -----------------------------
# Основные переменные
# -----------------------------
export EDITOR="nvim"
export VISUAL="nvim"
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"

# -----------------------------
# Antidote — менеджер плагинов
# -----------------------------
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load

# -----------------------------
# Starship prompt
# -----------------------------
eval "$(starship init zsh)"
export STARSHIP_CONFIG="$HOME/.config/starship.toml"

# -----------------------------
# Алиасы
# -----------------------------
alias ll='ls -la --color=auto'
alias la='ls -A'
alias l='ls -CF'


# === Редакторы ===
alias vi='nvim'
# === Файловый менеджер ===
alias y='yazi'

# === Git ===
alias g='lazygit'
alias lg='lazygit'
alias d='delta'
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'

# === Мониторинг ===
alias top='btop'
alias bt='btop'
alias htop='btop'

# === JSON ===
alias jq='jq'
alias jj='jq'

# === HTTP ===
alias h='http'
alias http='http'

# === Навигация ===
alias zo='z'

# === Поиск ===
alias rg='rg'
alias rgg='rg --hidden --glob "!.git"'

# === Утилиты ===
alias cle='clear'
alias ..='cd ..'
alias ...='cd ../..'


# -----------------------------
# История
# -----------------------------
export HISTFILE=~/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS

# -----------------------------
# Комфортные настройки
# -----------------------------
autoload -U colors && colors
setopt AUTO_CD
setopt CORRECT
setopt NO_BEEP
bindkey -e

# -----------------------------
# Навигация и fuzzy finder
# -----------------------------
eval "$(zoxide init zsh)"

# FZF интерактивн
alias zi='__zi_fzf'

__zi_fzf() {
  local dir
  dir=$(zoxide query -l | fzf --height 40% --border --reverse --prompt="Jump to   " --color=16 --ansi)
  if [[ -n "$dir" ]]; then
    cd "$dir" || return
  fi
}

# -----------------------------
# FZF цвета под cybergreen
# -----------------------------
export FZF_DEFAULT_OPTS="
  --color=bg+:#000000,bg:#000000,spinner:#66FF99,hl:#55BBAA
  --color=fg:#66FF99,header:#55BBAA,info:#66FF99,pointer:#55BBAA
  --color=marker:#66FF99,fg+:#99FFBB,prompt:#55BBAA,hl+:#66FF99
  --layout=reverse --border --height=40%
"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export GOOGLE_CLOUD_PROJECT="data-avatar-475416-s2"

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
