#!/bin/bash
#
# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                     SETUP NARSIL - MACBOOK AIR M4                         ║
# ║                                                                           ║
# ║  Installa Homebrew, Oh-My-Zsh, Powerlevel10k e tutti i programmi          ║
# ║  configurando l'accesso per due utenti con cache condivisa.               ║
# ╚═══════════════════════════════════════════════════════════════════════════╝
#
# Uso: ./setup-narsil.sh [--dry-run] [--reset]
#
#   --dry-run  Mostra cosa verrebbe fatto senza eseguire
#   --reset    Cancella il progresso salvato e ricomincia da zero
#

set -e  # Esci in caso di errore

# ═══════════════════════════════════════════════════════════════════════════
# COLORI E FORMATTAZIONE
# ═══════════════════════════════════════════════════════════════════════════
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# ═══════════════════════════════════════════════════════════════════════════
# FUNZIONI DI UTILITA
# ═══════════════════════════════════════════════════════════════════════════
print_header() {
    echo ""
    echo -e "${PURPLE}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${NC} ${BOLD}$1${NC}"
    echo -e "${PURPLE}╚═══════════════════════════════════════════════════════════════╝${NC}"
}

print_step() {
    echo -e "${CYAN}▶${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# ═══════════════════════════════════════════════════════════════════════════
# CONFIGURAZIONE - MODIFICA QUI LE CATEGORIE
# ═══════════════════════════════════════════════════════════════════════════

# Formule CLI
INSTALL_DEV_TOOLS=true        # Git, Node, Docker, etc.
INSTALL_CLI_ESSENTIALS=true   # bat, eza, fzf, jq, etc.
INSTALL_TERMINAL_SHELL=true   # zsh plugins, tmux, thefuck
INSTALL_NETWORKING=true       # wget, nmap, aria2
INSTALL_MULTIMEDIA=true       # ffmpeg, imagemagick, yt-dlp
INSTALL_DOCUMENTS=true        # pandoc, ocrmypdf, tesseract
INSTALL_AI_TOOLS=true         # gemini-cli
INSTALL_FUN_GAMES=true        # cowsay, sl, figlet
INSTALL_DATABASES=true        # mysql, postgresql

# Applicazioni (Cask)
INSTALL_CASK_BROWSERS=true    # Chrome, Firefox, Brave
INSTALL_CASK_DEV=true         # VS Code, iTerm2, Docker Desktop
INSTALL_CASK_PRODUCTIVITY=true # Obsidian, Notion, Slack
INSTALL_CASK_MULTIMEDIA=true  # VLC, Audacity, HandBrake
INSTALL_CASK_UTILITIES=true   # UTM, Cyberduck
INSTALL_CASK_COMMUNICATION=true # WhatsApp, Discord, Zoom
INSTALL_CASK_ENTERTAINMENT=true # Steam, Epic Games

# ═══════════════════════════════════════════════════════════════════════════
# VARIABILI
# ═══════════════════════════════════════════════════════════════════════════
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIGS_DIR="$SCRIPT_DIR/configs"
LOG_FILE="$HOME/setup-narsil.log"
PROGRESS_FILE="$HOME/.setup-narsil-progress"
DRY_RUN=false

# Controlla flag --dry-run
if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN=true
    print_warning "MODALITA DRY-RUN: nessuna modifica verra effettuata"
fi

# Controlla flag --reset per ricominciare da zero
if [[ "$1" == "--reset" ]]; then
    rm -f "$PROGRESS_FILE"
    print_success "Progresso resettato. Esegui di nuovo lo script senza --reset"
    exit 0
fi

# ═══════════════════════════════════════════════════════════════════════════
# SISTEMA DI CHECKPOINT (Resume dopo interruzione)
# ═══════════════════════════════════════════════════════════════════════════
mark_phase_done() {
    local phase="$1"
    if [ "$DRY_RUN" = false ]; then
        echo "$phase" >> "$PROGRESS_FILE"
    fi
}

is_phase_done() {
    local phase="$1"
    grep -q "^${phase}$" "$PROGRESS_FILE" 2>/dev/null
}

# Mostra stato se esiste progresso precedente
if [ -f "$PROGRESS_FILE" ]; then
    print_info "Rilevato progresso precedente. Le fasi completate verranno saltate."
    print_info "Per ricominciare da zero: ./setup-narsil.sh --reset"
fi

# ═══════════════════════════════════════════════════════════════════════════
# LISTA FORMULE E CASK
# ═══════════════════════════════════════════════════════════════════════════

# DEV_TOOLS
FORMULAS_DEV_TOOLS=(
    git gh glab lazygit gitup hub #git-extras
    delta difftastic  # Git diff potenziati
    node nvm ppm
    docker docker-compose
    #eslint prettier
    #cmake php
    act  # GitHub Actions locale
)

# CLI_ESSENTIALS
FORMULAS_CLI_ESSENTIALS=(
    fzf bat eza ripgrep fd  # Core moderni (find, grep, ls, cat)
    tldr  # Man pages semplificate
    zoxide  # cd intelligente
    htop bottom procs  # Monitor processi
    tree watch #jq jsonlint
    dust duf  # Disk usage moderni
    broot ranger glow #most
    dos2unix gzip #duti
    fastfetch
)

# TERMINAL_SHELL
FORMULAS_TERMINAL_SHELL=(
    zsh-autosuggestions zsh-autocomplete zsh-syntax-highlighting
    tmux #fish
    thefuck navi
)

# NETWORKING
FORMULAS_NETWORKING=(
    wget httpie
    nmap speedtest-cli telnet #socat
    transmission-cli
)

# MULTIMEDIA
FORMULAS_MULTIMEDIA=(
    ffmpeg imagemagick yt-dlp
    exiftool potrace
    handbrake
)

# DOCUMENTS
FORMULAS_DOCUMENTS=(
    pandoc typst ocrmypdf
    tesseract tesseract-lang pdftk-java
    ghostscript img2pdf qrencode
)

# AI_TOOLS
FORMULAS_AI_TOOLS=(
    gemini-cli aws-cli copilot
    ollama  # LLM locali (Llama, Mistral, ecc.)
    aichat  # CLI per chattare con LLM
)

# FUN_GAMES
FORMULAS_FUN_GAMES=(
    cowsay figlet fortune lolcat toilet
    sl asciiquarium ninvaders pipes-sh
    open-adventure zboy
)

# DATABASES
FORMULAS_DATABASES=(
    mysql postgresql@14 pgcli
    sqlite
)

# ═══════════════════════════════════════════════════════════════════════════
# LISTA CASK
# ═══════════════════════════════════════════════════════════════════════════

CASKS_BROWSERS=(
    google-chrome #firefox brave-browser tor-browser
)

CASKS_DEV=(
    visual-studio-code #cursor  # Editor con AI
    iterm2 #warp  # Terminali
    docker-desktop
    github tableplus claude claude-code mistral-vibe codex #gitkraken
)

CASKS_PRODUCTIVITY=(
    obsidian #notion notion-calendar  # Knowledge & Learning
    anki
    #raycast  # Launcher potenziato (sostituisce Spotlight)
    #figma  # Design
)

CASKS_MULTIMEDIA=(
    vlc audacity handbrake calibre #inkscape
    #obs  # Streaming & recording
    #davinci-resolve  # Video editing professionale
)

CASKS_UTILITIES=(
    utm cyberduck #ccleaner
    raspberry-pi-imager
    macfuse ntfstool
    #rectangle alt-tab  # Window management
    #stats  # Monitor menubar
    #appcleaner  # Disinstallatore completo
    #keka  # Archiver
    #bartender  # Menubar organizer
)

CASKS_COMMUNICATION=(
    whatsapp discord zoom telegram
)

CASKS_ENTERTAINMENT=(
    steam epic-games
)

# ═══════════════════════════════════════════════════════════════════════════
# FUNZIONI DI INSTALLAZIONE
# ═══════════════════════════════════════════════════════════════════════════

run_cmd() {
    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}[DRY-RUN]${NC} $*"
    else
        "$@" 2>&1 | tee -a "$LOG_FILE"
    fi
}

install_formulas() {
    local category="$1"
    shift
    local formulas=("$@")

    print_step "Installando formule: $category"
    for formula in "${formulas[@]}"; do
        if brew list "$formula" &>/dev/null; then
            print_info "$formula gia installato"
        else
            run_cmd brew install "$formula" || print_warning "Errore installando $formula"
        fi
    done
    print_success "$category completato"
}

install_casks() {
    local category="$1"
    shift
    local casks=("$@")

    print_step "Installando applicazioni: $category"
    for cask in "${casks[@]}"; do
        if brew list --cask "$cask" &>/dev/null; then
            print_info "$cask gia installato"
        else
            run_cmd brew install --cask "$cask" || print_warning "Errore installando $cask"
        fi
    done
    print_success "$category completato"
}

# ═══════════════════════════════════════════════════════════════════════════
# INIZIO SCRIPT
# ═══════════════════════════════════════════════════════════════════════════

clear
echo ""
echo -e "${BOLD}${PURPLE}"
cat << "EOF"
 ____  _____ _____ _   _ ____    _   _    _    ____  ____ ___ _     
/ ___|| ____|_   _| | | |  _ \  | \ | |  / \  |  _ \/ ___|_ _| |    
\___ \|  _|   | | | | | | |_) | |  \| | / _ \ | |_) \___ \| || |    
 ___) | |___  | | | |_| |  __/  | |\  |/ ___ \|  _ < ___) | || |___ 
|____/|_____| |_|  \___/|_|     |_| \_/_/   \_\_| \_\____/___|_____|
                                                                    
EOF
echo -e "${NC}"
echo -e "${CYAN}⚔️  La spada che fu spezzata, riforgiata per il tuo Mac ⚔️${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Richiedi nome secondo utente
print_header "CONFIGURAZIONE INIZIALE"
read -p "Inserisci il nome utente del secondo account (lascia vuoto per saltare): " SECOND_USER

if [ -n "$SECOND_USER" ]; then
    print_info "Secondo utente configurato: $SECOND_USER"
else
    print_warning "Nessun secondo utente - la condivisione non sara configurata"
fi

echo ""
read -p "Premi INVIO per iniziare l'installazione (o Ctrl+C per annullare)..."

# Inizia log
echo "=== Setup Narsil - $(date) ===" > "$LOG_FILE"

# ═══════════════════════════════════════════════════════════════════════════
# FASE 1: XCODE COMMAND LINE TOOLS
# ═══════════════════════════════════════════════════════════════════════════
print_header "FASE 1: Xcode Command Line Tools"

if xcode-select -p &>/dev/null; then
    print_success "Xcode CLI Tools gia installato"
else
    print_step "Installando Xcode Command Line Tools..."
    run_cmd xcode-select --install
    print_warning "Attendi il completamento dell'installazione e poi riesegui lo script"
    exit 0
fi

# ═══════════════════════════════════════════════════════════════════════════
# FASE 2: HOMEBREW
# ═══════════════════════════════════════════════════════════════════════════
print_header "FASE 2: Homebrew"

if command -v brew &>/dev/null; then
    print_success "Homebrew gia installato"
else
    print_step "Installando Homebrew..."
    run_cmd /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Configura PATH per la sessione corrente
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # Aggiungi a .zprofile
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
fi

print_step "Aggiornando Homebrew..."
run_cmd brew update

# ═══════════════════════════════════════════════════════════════════════════
# FASE 3: CONFIGURAZIONE MULTI-UTENTE
# ═══════════════════════════════════════════════════════════════════════════
if [ -n "$SECOND_USER" ]; then
    print_header "FASE 3: Configurazione Multi-Utente"

    print_step "Creando gruppo 'brew'..."
    if ! dscl . -read /Groups/brew &>/dev/null; then
        run_cmd sudo dseditgroup -o create brew
    fi

    print_step "Aggiungendo utenti al gruppo brew..."
    run_cmd sudo dseditgroup -o edit -a "$(whoami)" -t user brew
    run_cmd sudo dseditgroup -o edit -a "$SECOND_USER" -t user brew

    print_step "Configurando permessi su /opt/homebrew..."
    run_cmd sudo chgrp -R brew /opt/homebrew
    run_cmd sudo chmod -R g+rwX /opt/homebrew

    # Sticky bit per nuovi file
    run_cmd sudo chmod g+s /opt/homebrew
    run_cmd sudo chmod g+s /opt/homebrew/Cellar

    # Configura cache condivisa Homebrew
    print_step "Configurando cache Homebrew condivisa..."
    SHARED_CACHE="/opt/homebrew/Caches"
    run_cmd sudo mkdir -p "$SHARED_CACHE"
    run_cmd sudo chgrp -R brew "$SHARED_CACHE"
    run_cmd sudo chmod -R g+rwX "$SHARED_CACHE"
    run_cmd sudo chmod g+s "$SHARED_CACHE"

    # Aggiungi export HOMEBREW_CACHE al .zshrc dell'utente corrente
    if ! grep -q "HOMEBREW_CACHE" "$HOME/.zshrc" 2>/dev/null; then
        print_step "Aggiungendo HOMEBREW_CACHE al .zshrc..."
        echo '' >> "$HOME/.zshrc"
        echo '# Cache Homebrew condivisa per multi-utente' >> "$HOME/.zshrc"
        echo 'export HOMEBREW_CACHE=/opt/homebrew/Caches' >> "$HOME/.zshrc"
    fi

    # Aggiungi anche al .zprofile per essere sicuri
    if ! grep -q "HOMEBREW_CACHE" "$HOME/.zprofile" 2>/dev/null; then
        echo 'export HOMEBREW_CACHE=/opt/homebrew/Caches' >> "$HOME/.zprofile"
    fi

    print_success "Configurazione multi-utente completata"
fi

# ═══════════════════════════════════════════════════════════════════════════
# FASE 4: FONT MESLO PER POWERLEVEL10K
# ═══════════════════════════════════════════════════════════════════════════
print_header "FASE 4: Font MesloLGS NF"

FONT_DIR="/Library/Fonts"
MESLO_BASE_URL="https://github.com/romkatv/powerlevel10k-media/raw/master"

print_step "Scaricando font MesloLGS NF..."

fonts=(
    "MesloLGS%20NF%20Regular.ttf"
    "MesloLGS%20NF%20Bold.ttf"
    "MesloLGS%20NF%20Italic.ttf"
    "MesloLGS%20NF%20Bold%20Italic.ttf"
)

for font in "${fonts[@]}"; do
    font_name=$(echo "$font" | sed 's/%20/ /g')
    if [ -f "$FONT_DIR/$font_name" ]; then
        print_info "$font_name gia presente"
    else
        run_cmd sudo curl -L -o "$FONT_DIR/$font_name" "$MESLO_BASE_URL/$font"
    fi
done

print_success "Font installati"

# ═══════════════════════════════════════════════════════════════════════════
# FASE 5: OH-MY-ZSH
# ═══════════════════════════════════════════════════════════════════════════
print_header "FASE 5: Oh-My-Zsh"

if [ -d "$HOME/.oh-my-zsh" ]; then
    print_success "Oh-My-Zsh gia installato"
else
    print_step "Installando Oh-My-Zsh..."
    run_cmd sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# ═══════════════════════════════════════════════════════════════════════════
# FASE 6: POWERLEVEL10K
# ═══════════════════════════════════════════════════════════════════════════
print_header "FASE 6: Powerlevel10k"

P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

if [ -d "$P10K_DIR" ]; then
    print_success "Powerlevel10k gia installato"
else
    print_step "Clonando Powerlevel10k..."
    run_cmd git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

# ═══════════════════════════════════════════════════════════════════════════
# FASE 7: INSTALLA FORMULE
# ═══════════════════════════════════════════════════════════════════════════
if is_phase_done "FASE_7"; then
    print_info "FASE 7 già completata - saltata"
else
    print_header "FASE 7: Installazione Formule Homebrew"

    if [ "$INSTALL_DEV_TOOLS" = true ]; then
        install_formulas "Dev Tools" "${FORMULAS_DEV_TOOLS[@]}"
    fi

    if [ "$INSTALL_CLI_ESSENTIALS" = true ]; then
        install_formulas "CLI Essentials" "${FORMULAS_CLI_ESSENTIALS[@]}"
    fi

    if [ "$INSTALL_TERMINAL_SHELL" = true ]; then
        install_formulas "Terminal & Shell" "${FORMULAS_TERMINAL_SHELL[@]}"
    fi

    if [ "$INSTALL_NETWORKING" = true ]; then
        install_formulas "Networking" "${FORMULAS_NETWORKING[@]}"
    fi

    if [ "$INSTALL_MULTIMEDIA" = true ]; then
        install_formulas "Multimedia" "${FORMULAS_MULTIMEDIA[@]}"
    fi

    if [ "$INSTALL_DOCUMENTS" = true ]; then
        install_formulas "Documents" "${FORMULAS_DOCUMENTS[@]}"
    fi

    if [ "$INSTALL_AI_TOOLS" = true ]; then
        install_formulas "AI Tools" "${FORMULAS_AI_TOOLS[@]}"
    fi

    if [ "$INSTALL_FUN_GAMES" = true ]; then
        install_formulas "Fun & Games" "${FORMULAS_FUN_GAMES[@]}"
    fi

    if [ "$INSTALL_DATABASES" = true ]; then
        install_formulas "Databases" "${FORMULAS_DATABASES[@]}"
    fi

    mark_phase_done "FASE_7"
fi

# ═══════════════════════════════════════════════════════════════════════════
# FASE 8: INSTALLA CASK
# ═══════════════════════════════════════════════════════════════════════════
if is_phase_done "FASE_8"; then
    print_info "FASE 8 già completata - saltata"
else
    print_header "FASE 8: Installazione Applicazioni (Cask)"

    if [ "$INSTALL_CASK_BROWSERS" = true ]; then
        install_casks "Browsers" "${CASKS_BROWSERS[@]}"
    fi

    if [ "$INSTALL_CASK_DEV" = true ]; then
        install_casks "Development" "${CASKS_DEV[@]}"
    fi

    if [ "$INSTALL_CASK_PRODUCTIVITY" = true ]; then
        install_casks "Productivity" "${CASKS_PRODUCTIVITY[@]}"
    fi

    if [ "$INSTALL_CASK_MULTIMEDIA" = true ]; then
        install_casks "Multimedia" "${CASKS_MULTIMEDIA[@]}"
    fi

    if [ "$INSTALL_CASK_UTILITIES" = true ]; then
        install_casks "Utilities" "${CASKS_UTILITIES[@]}"
    fi

    if [ "$INSTALL_CASK_COMMUNICATION" = true ]; then
        install_casks "Communication" "${CASKS_COMMUNICATION[@]}"
    fi

    if [ "$INSTALL_CASK_ENTERTAINMENT" = true ]; then
        install_casks "Entertainment" "${CASKS_ENTERTAINMENT[@]}"
    fi

    mark_phase_done "FASE_8"
fi

# ═══════════════════════════════════════════════════════════════════════════
# FASE 9: COPIA CONFIGURAZIONI
# ═══════════════════════════════════════════════════════════════════════════
print_header "FASE 9: Configurazioni Personalizzate"

if [ -d "$CONFIGS_DIR" ]; then
    print_step "Copiando configurazione zsh..."
    if [ -f "$CONFIGS_DIR/.zshrc" ]; then
        # Backup esistente
        [ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
        cp "$CONFIGS_DIR/.zshrc" "$HOME/.zshrc"
        print_success ".zshrc copiato"
    fi

    print_step "Copiando configurazione Powerlevel10k..."
    if [ -f "$CONFIGS_DIR/.p10k.zsh" ]; then
        cp "$CONFIGS_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
        print_success ".p10k.zsh copiato"
    fi

    print_step "Copiando configurazione fzf..."
    if [ -f "$CONFIGS_DIR/.fzf.zsh" ]; then
        cp "$CONFIGS_DIR/.fzf.zsh" "$HOME/.fzf.zsh"
        print_success ".fzf.zsh copiato"
    fi

    print_step "Copiando configurazione broot..."
    if [ -d "$CONFIGS_DIR/broot" ]; then
        mkdir -p "$HOME/.config/broot"
        cp "$CONFIGS_DIR/broot/"* "$HOME/.config/broot/"
        print_success "broot config copiato"
    fi

    print_step "Importando profilo iTerm2..."
    if [ -f "$CONFIGS_DIR/iterm2-profile.plist" ]; then
        # Importa il profilo in iTerm2
        # iTerm2 deve essere stato avviato almeno una volta
        if [ -f "$HOME/Library/Preferences/com.googlecode.iterm2.plist" ]; then
            /usr/libexec/PlistBuddy -c "Add :New\ Bookmarks:0 dict" ~/Library/Preferences/com.googlecode.iterm2.plist 2>/dev/null || true
            /usr/libexec/PlistBuddy -c "Merge '$CONFIGS_DIR/iterm2-profile.plist' :New\ Bookmarks:0" ~/Library/Preferences/com.googlecode.iterm2.plist 2>/dev/null
            print_success "Profilo iTerm2 importato"
        else
            print_warning "Avvia iTerm2 una volta e riesegui lo script per importare il profilo"
        fi
    fi
else
    print_warning "Cartella configs/ non trovata - configurazioni saltate"
fi

# ═══════════════════════════════════════════════════════════════════════════
# FASE 10: CONFIGURAZIONE SECONDO UTENTE
# ═══════════════════════════════════════════════════════════════════════════
if [ -n "$SECOND_USER" ]; then
    print_header "FASE 10: Configurazione Secondo Utente"

    SECOND_USER_HOME="/Users/$SECOND_USER"

    if [ -d "$SECOND_USER_HOME" ]; then
        print_step "Copiando .zshrc per $SECOND_USER..."
        run_cmd sudo cp "$HOME/.zshrc" "$SECOND_USER_HOME/.zshrc"
        run_cmd sudo chown "$SECOND_USER:staff" "$SECOND_USER_HOME/.zshrc"

        print_step "Copiando .p10k.zsh per $SECOND_USER..."
        run_cmd sudo cp "$HOME/.p10k.zsh" "$SECOND_USER_HOME/.p10k.zsh"
        run_cmd sudo chown "$SECOND_USER:staff" "$SECOND_USER_HOME/.p10k.zsh"

        print_step "Configurando PATH Homebrew per $SECOND_USER..."
        run_cmd sudo -u "$SECOND_USER" bash -c 'echo '\''eval "$(/opt/homebrew/bin/brew shellenv)"'\'' >> ~/.zprofile'

        # Configura cache condivisa per secondo utente
        print_step "Configurando cache Homebrew condivisa per $SECOND_USER..."
        if ! sudo grep -q "HOMEBREW_CACHE" "$SECOND_USER_HOME/.zshrc" 2>/dev/null; then
            sudo bash -c "echo '' >> $SECOND_USER_HOME/.zshrc"
            sudo bash -c "echo '# Cache Homebrew condivisa per multi-utente' >> $SECOND_USER_HOME/.zshrc"
            sudo bash -c "echo 'export HOMEBREW_CACHE=/opt/homebrew/Caches' >> $SECOND_USER_HOME/.zshrc"
        fi
        if ! sudo grep -q "HOMEBREW_CACHE" "$SECOND_USER_HOME/.zprofile" 2>/dev/null; then
            sudo bash -c "echo 'export HOMEBREW_CACHE=/opt/homebrew/Caches' >> $SECOND_USER_HOME/.zprofile"
        fi

        print_step "Installando Oh-My-Zsh per $SECOND_USER..."
        if [ ! -d "$SECOND_USER_HOME/.oh-my-zsh" ]; then
            run_cmd sudo -u "$SECOND_USER" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        fi

        print_step "Clonando Powerlevel10k per $SECOND_USER..."
        SECOND_P10K_DIR="$SECOND_USER_HOME/.oh-my-zsh/custom/themes/powerlevel10k"
        if [ ! -d "$SECOND_P10K_DIR" ]; then
            run_cmd sudo -u "$SECOND_USER" git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$SECOND_P10K_DIR"
        fi

        print_success "Secondo utente configurato"
    else
        print_error "Home del secondo utente non trovata: $SECOND_USER_HOME"
    fi
fi

# ═══════════════════════════════════════════════════════════════════════════
# FASE 11: PULIZIA E FINALIZZAZIONE
# ═══════════════════════════════════════════════════════════════════════════
print_header "FASE 11: Finalizzazione"

print_step "Pulizia cache Homebrew..."
run_cmd brew cleanup

print_step "Impostando zsh come shell predefinita..."
if ! grep -q "/opt/homebrew/bin/zsh" /etc/shells; then
    echo '/opt/homebrew/bin/zsh' | sudo tee -a /etc/shells
fi
run_cmd chsh -s /opt/homebrew/bin/zsh

# ═══════════════════════════════════════════════════════════════════════════
# COMPLETATO
# ═══════════════════════════════════════════════════════════════════════════

# Rimuovi file di progresso (installazione completata con successo)
rm -f "$PROGRESS_FILE"

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}${BOLD}              ⚔️  NARSIL È STATA RIFORGIATA! ⚔️                    ${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${CYAN}Prossimi passi:${NC}"
echo -e "  1. Chiudi e riapri il terminale (o esegui: ${BOLD}source ~/.zshrc${NC})"
echo -e "  2. Configura il font ${BOLD}MesloLGS NF${NC} in iTerm2:"
echo -e "     Preferences > Profiles > Text > Font"
echo -e "  3. Al primo avvio, Powerlevel10k chiedera la configurazione"
echo ""
echo -e "${CYAN}Log salvato in:${NC} $LOG_FILE"
echo ""
