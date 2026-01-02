# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                              ZSH CONFIGURATION                            ║
# ║                         Ottimizzato per macOS + Apple Silicon             ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

# ═══════════════════════════════════════════════════════════════════════════════
# SEZIONE 1: INIZIALIZZAZIONE CRITICA (deve stare in cima)
# ═══════════════════════════════════════════════════════════════════════════════

# Powerlevel10k Instant Prompt - velocizza l'avvio mostrando il prompt immediatamente
# Nota: se fastfetch causa glitch grafici, cambiare 'quiet' in 'off'
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Limiti di sistema - necessario per Claude Code via SSH
ulimit -n 2147483646

# ═══════════════════════════════════════════════════════════════════════════════
# SEZIONE 2: HOMEBREW
# ═══════════════════════════════════════════════════════════════════════════════

# Inizializza Homebrew (Apple Silicon: /opt/homebrew, Intel: /usr/local)
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Salva prefix per uso successivo
BREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"

# ═══════════════════════════════════════════════════════════════════════════════
# SEZIONE 3: OH-MY-ZSH
# ═══════════════════════════════════════════════════════════════════════════════

# Disabilita controllo sicurezza directory (necessario per Homebrew multi-utente)
ZSH_DISABLE_COMPFIX=true

# Configurazione base
export ZSH="$HOME/.oh-my-zsh"
DEFAULT_USER="$(whoami)"
ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_COLORIZE_TOOL=chroma

# Plugin Oh-My-Zsh
# Nota: fzf-tab DEVE essere primo per funzionare correttamente
plugins=(
  fzf-tab              # Completamento fuzzy con TAB (sostituisce zsh-interactive-cd)
  git                  # Alias git: gst, gco, gp, gl, gd, ga, gc, etc.
  brew                 # Alias brew: bubo, bubc, brewp, etc.
  colorize             # Syntax highlighting per cat: ccat, cless
  command-not-found    # Suggerisce pacchetti da installare per comandi mancanti
  macos                # Comandi macOS: ofd (apri Finder), cdf (cd to Finder), quick-look
  sudo                 # Doppio ESC aggiunge sudo al comando precedente
  extract              # Estrae qualsiasi archivio: extract file.zip/tar.gz/rar/etc.
  copypath             # Copia path corrente: copypath
  copyfile             # Copia contenuto file: copyfile file.txt
  aliases              # Lista tutti gli alias: als, als git
  docker               # Completamenti e alias docker
  docker-compose       # Completamenti docker-compose
  thefuck              # Corregge comandi sbagliati: fuck o ESC-ESC
)

source "$ZSH/oh-my-zsh.sh"

# ═══════════════════════════════════════════════════════════════════════════════
# SEZIONE 4: PLUGIN ZSH ESTERNI (da Homebrew)
# ═══════════════════════════════════════════════════════════════════════════════

# Autosuggestions - suggerisce comandi dalla cronologia
# Uso: freccia destra (→) per accettare, Ctrl+→ per accettare una parola
[[ -f "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
  source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Syntax highlighting - colora comandi validi/invalidi in tempo reale
# IMPORTANTE: deve essere caricato DOPO autosuggestions
[[ -f "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
  source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Git extras - completamento per comandi git-extras
[[ -f "$BREW_PREFIX/opt/git-extras/share/git-extras/git-extras-completion.zsh" ]] && \
  source "$BREW_PREFIX/opt/git-extras/share/git-extras/git-extras-completion.zsh"

# Fix compatibilita' Claude Code (rimuove alias = che interferisce)
unalias '=' 2>/dev/null

# ═══════════════════════════════════════════════════════════════════════════════
# SEZIONE 5: HISTORY - Configurazione cronologia comandi
# ═══════════════════════════════════════════════════════════════════════════════

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000                   # Comandi in memoria
SAVEHIST=50000                   # Comandi salvati su disco
setopt EXTENDED_HISTORY          # Salva timestamp
setopt HIST_EXPIRE_DUPS_FIRST    # Elimina duplicati prima
setopt HIST_IGNORE_DUPS          # Non salvare comandi duplicati consecutivi
setopt HIST_IGNORE_SPACE         # Comandi che iniziano con spazio non salvati
setopt HIST_VERIFY               # Mostra comando prima di eseguirlo dalla history
setopt SHARE_HISTORY             # Condividi history tra sessioni

# ═══════════════════════════════════════════════════════════════════════════════
# SEZIONE 6: ENVIRONMENT VARIABLES
# ═══════════════════════════════════════════════════════════════════════════════

# Editor predefinito (per git commit, crontab, etc.)
export EDITOR="nano"
export VISUAL="nano"

# Lingua e encoding
export LANG="it_IT.UTF-8"
export LC_ALL="it_IT.UTF-8"

# Meno pagine colorate
export LESS="-R"
export LESSHISTFILE=-

# ═══════════════════════════════════════════════════════════════════════════════
# SEZIONE 7: PATH
# ═══════════════════════════════════════════════════════════════════════════════

# Homebrew paths aggiuntivi
export PATH="$BREW_PREFIX/opt/icu4c/bin:$PATH"
export PATH="$BREW_PREFIX/opt/icu4c/sbin:$PATH"
export PATH="$BREW_PREFIX/sbin:$PATH"

# User binaries
export PATH="$HOME/.local/bin:$PATH"

# ═══════════════════════════════════════════════════════════════════════════════
# SEZIONE 8: ALIAS - Comandi migliorati
# ═══════════════════════════════════════════════════════════════════════════════

# ls moderno con icone e colori (richiede: brew install eza)
if command -v eza &>/dev/null; then
  alias ls="eza --icons --group-directories-first"
  alias ll="eza --icons --group-directories-first -la"
  alias lt="eza --icons --tree --level=2"
  alias lta="eza --icons --tree --level=2 -a"
fi

# cat con syntax highlighting (richiede: brew install bat)
if command -v bat &>/dev/null; then
  alias cat="bat --paging=never"
  alias catp="bat"  # cat con pager
fi

# Navigazione directory
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Conferma operazioni distruttive
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"

# Trash invece di rm (richiede: brew install trash)
command -v trash &>/dev/null && alias del="trash"

# Grep colorato
alias grep="grep --color=auto"

# ═══════════════════════════════════════════════════════════════════════════════
# SEZIONE 9: ALIAS - Applicazioni
# ═══════════════════════════════════════════════════════════════════════════════

alias kindle="open /Applications/Amazon\ Kindle.app"
alias tor="open /Applications/Tor\ Browser.app"
alias sman="/usr/bin/man"  # man di sistema (bypass di altri man)

# ═══════════════════════════════════════════════════════════════════════════════
# SEZIONE 10: ALIAS - Directory frequenti
# ═══════════════════════════════════════════════════════════════════════════════

alias 2Brain="cd ~/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/Second\ Brain\ Ema/"

# ═══════════════════════════════════════════════════════════════════════════════
# SEZIONE 11: ALIAS - Sistema e manutenzione
# ═══════════════════════════════════════════════════════════════════════════════

# Aggiorna tutto: brew + cask + MAS
alias aggiorna="brew upgrade && brew update && brew cu -via --no-brew-update --include-mas --cleanup"

# Pulizia sistema
alias cleanup="brew cleanup -s && brew autoremove"

# Mostra spazio disco
alias disk="df -h | grep -E '^/dev/|Filesystem'"

# IP locale e pubblico
alias ip="echo 'Local:' && ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1; echo 'Public:' && curl -s ifconfig.me"

# ═══════════════════════════════════════════════════════════════════════════════
# SEZIONE 12: FUNZIONI UTILI
# ═══════════════════════════════════════════════════════════════════════════════

# mkcd - crea directory e ci entra
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# extract - estrae qualsiasi archivio (backup se plugin non funziona)
ex() {
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz)  tar xzf "$1" ;;
      *.tar.xz)  tar xJf "$1" ;;
      *.bz2)     bunzip2 "$1" ;;
      *.gz)      gunzip "$1" ;;
      *.tar)     tar xf "$1" ;;
      *.tbz2)    tar xjf "$1" ;;
      *.tgz)     tar xzf "$1" ;;
      *.zip)     unzip "$1" ;;
      *.Z)       uncompress "$1" ;;
      *.7z)      7z x "$1" ;;
      *.rar)     unrar x "$1" ;;
      *) echo "'$1' non puo' essere estratto" ;;
    esac
  else
    echo "'$1' non e' un file valido"
  fi
}

# ports - mostra porte in uso
ports() {
  if [[ -n "$1" ]]; then
    lsof -i :"$1" | grep LISTEN
  else
    lsof -i -P | grep LISTEN
  fi
}

# weather - meteo veloce (usa wttr.in)
weather() {
  local city="${1:-Rome}"
  curl -s "wttr.in/${city}?format=3"
}

# brewd - lista pacchetti brew per data installazione
brewd() {
  brew leaves --installed-on-request | while read f; do
    echo "$(stat -f '%Sm' -t '%Y-%m-%d %H:%M:%S' "$(brew --cellar)/$f")  →  $f"
  done | sort -r
}

# ═══════════════════════════════════════════════════════════════════════════════
# SEZIONE 13: CUBBIT DS3 - Storage cloud S3-compatibile
# Prerequisito: aws configure --profile cubbit
# ═══════════════════════════════════════════════════════════════════════════════

cubbit() {
  local cmd="$1"
  shift
  local endpoint="https://s3.cubbit.eu"
  local profile="cubbit"

  case "$cmd" in
    ls)    aws s3 --endpoint "$endpoint" --profile "$profile" ls "$@" ;;
    cp)    aws s3 --endpoint "$endpoint" --profile "$profile" cp "$@" ;;
    mv)    aws s3 --endpoint "$endpoint" --profile "$profile" mv "$@" ;;
    rm)    aws s3 --endpoint "$endpoint" --profile "$profile" rm "$@" ;;
    sync)  aws s3 --endpoint "$endpoint" --profile "$profile" sync "$@" ;;
    mb)    aws s3 --endpoint "$endpoint" --profile "$profile" mb "$@" ;;
    rb)    aws s3 --endpoint "$endpoint" --profile "$profile" rb "$@" ;;
    size)  aws s3 --endpoint "$endpoint" --profile "$profile" ls "s3://$1" --recursive --summarize --human-readable | tail -2 ;;
    share) aws s3 --endpoint "$endpoint" --profile "$profile" presign "s3://$1" --expires-in "${2:-3600}" ;;
    help|"")
      cat << 'EOF'
Cubbit DS3 - Comandi disponibili:

  cubbit ls [bucket]              Lista bucket o contenuti
  cubbit cp <src> <dst>           Copia file (locale <-> s3)
  cubbit mv <src> <dst>           Sposta file
  cubbit rm <path>                Elimina file
  cubbit sync <src> <dst>         Sincronizza cartelle
  cubbit mb s3://nome             Crea bucket
  cubbit rb s3://nome             Elimina bucket
  cubbit size <bucket>            Mostra spazio usato
  cubbit share <bucket/file> [s]  Genera link temporaneo (default 1h)

Esempi:
  cubbit ls                       Lista tutti i bucket
  cubbit ls s3://pollo/           Contenuto bucket pollo
  cubbit cp foto.jpg s3://pollo/
  cubbit sync ~/Foto s3://pollo/backup/
  cubbit share pollo/foto.jpg 86400   Link valido 24h
EOF
      ;;
    *)
      echo "Comando non riconosciuto. Usa 'cubbit help' per la lista."
      return 1
      ;;
  esac
}

# ═══════════════════════════════════════════════════════════════════════════════
# SEZIONE 14: TOOL ESTERNI
# ═══════════════════════════════════════════════════════════════════════════════

# thefuck - corregge comandi sbagliati (alias: fuck)
command -v thefuck &>/dev/null && eval "$(thefuck --alias)"

# navi - cheatsheet interattivo (Ctrl+G)
command -v navi &>/dev/null && eval "$(navi widget zsh)"

# zoxide - navigazione smart (z folder invece di cd path/to/folder)
# Impara le directory visitate e permette di raggiungerle con poche lettere
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# ═══════════════════════════════════════════════════════════════════════════════
# SEZIONE 15: SOURCE ESTERNI
# ═══════════════════════════════════════════════════════════════════════════════

# fzf - fuzzy finder (Ctrl+R per history, Ctrl+T per file)
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# broot - file manager (br)
[[ -f "$HOME/.config/broot/launcher/bash/br" ]] && source "$HOME/.config/broot/launcher/bash/br"

# ═══════════════════════════════════════════════════════════════════════════════
# SEZIONE 16: POWERLEVEL10K
# ═══════════════════════════════════════════════════════════════════════════════

# Carica configurazione P10k (generata con: p10k configure)
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ═══════════════════════════════════════════════════════════════════════════════
# SEZIONE 17: STARTUP (alla fine per avere tutto inizializzato)
# ═══════════════════════════════════════════════════════════════════════════════

# Mostra info sistema all'avvio (richiede: brew install fastfetch)
command -v fastfetch &>/dev/null && fastfetch --pipe false 2>/dev/null

# ═══════════════════════════════════════════════════════════════════════════════
# FINE CONFIGURAZIONE
# Per ricaricare: source ~/.zshrc oppure exec zsh
# ═══════════════════════════════════════════════════════════════════════════════
