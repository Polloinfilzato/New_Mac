# ═══════════════════════════════════════════════════════════════
# POWERLEVEL10K - Instant Prompt (deve stare in cima)
# ═══════════════════════════════════════════════════════════════
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ═══════════════════════════════════════════════════════════════
# HOMEBREW - Configurazione PATH (Apple Silicon)
# ═══════════════════════════════════════════════════════════════
eval "$(/opt/homebrew/bin/brew shellenv)"

# ═══════════════════════════════════════════════════════════════
# OH-MY-ZSH - Configurazione
# ═══════════════════════════════════════════════════════════════
# Disabilita controllo sicurezza directory completamento (necessario per condivisione Homebrew multi-utente)
ZSH_DISABLE_COMPFIX=true

export ZSH="$HOME/.oh-my-zsh"
DEFAULT_USER="$(whoami)"
ZSH_THEME="powerlevel10k/powerlevel10k"
POWERLEVEL9K_MODE="awesome-patched"
ZSH_COLORIZE_TOOL=chroma

plugins=(
  brew
  battery
  colorize
  command-not-found
  macos
  sudo
  zsh-interactive-cd
  docker
  docker-compose
  thefuck
)

source $ZSH/oh-my-zsh.sh

# ═══════════════════════════════════════════════════════════════
# PLUGIN ZSH (compatibile Apple Silicon)
# ═══════════════════════════════════════════════════════════════
BREW_PREFIX="$(brew --prefix)"
[ -f "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
  source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[ -f "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
  source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
[ -f "$BREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh" ] && \
  source "$BREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
[ -f "$BREW_PREFIX/opt/git-extras/share/git-extras/git-extras-completion.zsh" ] && \
  source "$BREW_PREFIX/opt/git-extras/share/git-extras/git-extras-completion.zsh"

unalias '=' 2>/dev/null  # Fix Claude Code compatibility issue

# ═══════════════════════════════════════════════════════════════
# PATH
# ═══════════════════════════════════════════════════════════════
export PATH="$BREW_PREFIX/opt/icu4c/bin:$PATH"
export PATH="$BREW_PREFIX/opt/icu4c/sbin:$PATH"
export PATH="$BREW_PREFIX/sbin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# ═══════════════════════════════════════════════════════════════
# ALIAS - Applicazioni
# ═══════════════════════════════════════════════════════════════
alias kindle="open /Applications/Amazon\ Kindle.app"
alias tor="open /Applications/Tor\ Browser.app"
alias sman="/usr/bin/man"

# ═══════════════════════════════════════════════════════════════
# ALIAS - Directory
# ═══════════════════════════════════════════════════════════════
alias 2Brain="cd ~/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/Second\ Brain\ Ema/"

# ═══════════════════════════════════════════════════════════════
# CUBBIT DS3 - Comandi semplificati (configura prima aws configure --profile cubbit)
# ═══════════════════════════════════════════════════════════════
cubbit() {
    local cmd="$1"
    shift
    case "$cmd" in
        ls)      aws s3 --endpoint https://s3.cubbit.eu --profile cubbit ls "$@" ;;
        cp)      aws s3 --endpoint https://s3.cubbit.eu --profile cubbit cp "$@" ;;
        mv)      aws s3 --endpoint https://s3.cubbit.eu --profile cubbit mv "$@" ;;
        rm)      aws s3 --endpoint https://s3.cubbit.eu --profile cubbit rm "$@" ;;
        sync)    aws s3 --endpoint https://s3.cubbit.eu --profile cubbit sync "$@" ;;
        mb)      aws s3 --endpoint https://s3.cubbit.eu --profile cubbit mb "$@" ;;
        rb)      aws s3 --endpoint https://s3.cubbit.eu --profile cubbit rb "$@" ;;
        size)    aws s3 --endpoint https://s3.cubbit.eu --profile cubbit ls "s3://$1" --recursive --summarize --human-readable | tail -2 ;;
        share)   aws s3 --endpoint https://s3.cubbit.eu --profile cubbit presign "s3://$1" --expires-in "${2:-3600}" ;;
        help)
            echo "Comandi Cubbit disponibili:"
            echo "  cubbit ls [bucket]           - Lista bucket o contenuti"
            echo "  cubbit cp <src> <dst>        - Copia file (locale<->s3)"
            echo "  cubbit mv <src> <dst>        - Sposta file"
            echo "  cubbit rm <path>             - Elimina file"
            echo "  cubbit sync <src> <dst>      - Sincronizza cartelle"
            echo "  cubbit mb s3://nome          - Crea bucket"
            echo "  cubbit rb s3://nome          - Elimina bucket"
            echo "  cubbit size <bucket>         - Mostra spazio usato"
            echo "  cubbit share <bucket/file> [sec] - Genera link (default 1h)"
            echo ""
            echo "Esempi:"
            echo "  cubbit ls                    - Lista tutti i bucket"
            echo "  cubbit ls s3://pollo/        - Contenuto bucket pollo"
            echo "  cubbit cp foto.jpg s3://pollo/"
            echo "  cubbit sync ~/Foto s3://pollo/backup/"
            echo "  cubbit share pollo/foto.jpg 86400  - Link valido 24h"
            ;;
        *)
            echo "Comando non riconosciuto. Usa 'cubbit help' per la lista comandi."
            return 1
            ;;
    esac
}

# ═══════════════════════════════════════════════════════════════
# FUNZIONI UTILI
# ═══════════════════════════════════════════════════════════════
# Lista pacchetti brew ordinati per data di installazione
brewd() {
  brew leaves --installed-on-request | while read f; do
    echo "$(stat -f '%Sm' -t '%Y-%m-%d %H:%M:%S' $(brew --cellar)/$f)  →  $f"
  done | sort -r
}

# ═══════════════════════════════════════════════════════════════
# TOOL ESTERNI
# ═══════════════════════════════════════════════════════════════
command -v thefuck &>/dev/null && eval $(thefuck --alias)
command -v navi &>/dev/null && eval "$(navi widget zsh)"

# ═══════════════════════════════════════════════════════════════
# SOURCE ESTERNI
# ═══════════════════════════════════════════════════════════════
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f "$HOME/.config/broot/launcher/bash/br" ] && source "$HOME/.config/broot/launcher/bash/br"

# ═══════════════════════════════════════════════════════════════
# POWERLEVEL10K - Configurazione
# ═══════════════════════════════════════════════════════════════
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ═══════════════════════════════════════════════════════════════
# SYSTEM INFO (alla fine per avere i colori inizializzati)
# ═══════════════════════════════════════════════════════════════
command -v fastfetch &>/dev/null && fastfetch --pipe false 2>/dev/null
