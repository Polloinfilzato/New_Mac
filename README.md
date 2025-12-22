# Setup MacBook Air M4

Script per configurare rapidamente un nuovo MacBook Air M4 con Homebrew, Oh-My-Zsh, Powerlevel10k e tutte le applicazioni necessarie.

## Contenuto

```
New_Mac/
├── setup-mac.sh              # Script principale
├── configs/
│   ├── .zshrc                # Configurazione zsh
│   ├── .p10k.zsh             # Tema Powerlevel10k (colori prompt)
│   ├── .fzf.zsh              # Configurazione fzf
│   ├── iterm2-profile.plist  # Profilo iTerm2 "Bellafonte lowT"
│   └── broot/
│       ├── conf.hjson
│       └── verbs.hjson
└── README.md
```

## Istruzioni

### 1. Copia la cartella sul nuovo Mac

Usa uno di questi metodi:
- **AirDrop** (consigliato)
- **iCloud Drive** (già sincronizzata se usi lo stesso Apple ID)
- **Chiavetta USB**

### 2. Apri Terminale

Apri l'app **Terminale** (si trova in Applicazioni > Utility).

### 3. Vai nella cartella

```bash
cd ~/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/Second\ Brain\ Ema/PRJ/New_Mac
```

Oppure se l'hai copiata altrove:
```bash
cd /percorso/dove/hai/copiato/New_Mac
```

### 4. Esegui lo script

```bash
# Rendi eseguibile (necessario dopo la copia)
chmod +x setup-mac.sh

# Esegui
./setup-mac.sh
```

Oppure senza chmod:
```bash
bash setup-mac.sh
```

### 5. Modalità Dry-Run (opzionale)

Per vedere cosa farebbe lo script senza installare nulla:
```bash
./setup-mac.sh --dry-run
```

## Cosa installa lo script

### Fase 1-3: Base
- Xcode Command Line Tools
- Homebrew
- Gruppo "brew" per condivisione multi-utente

### Fase 4-6: Terminale
- Font MesloLGS NF (per icone nel terminale)
- Oh-My-Zsh
- Powerlevel10k (tema)

### Fase 7: Formule CLI
| Categoria | Programmi |
|-----------|-----------|
| Dev Tools | git, gh, node, docker, eslint, prettier... |
| CLI Essentials | bat, eza, fzf, jq, htop, tree... |
| Terminal | zsh plugins, tmux, thefuck, navi |
| Networking | wget, aria2, nmap, speedtest-cli... |
| Multimedia | ffmpeg, imagemagick, yt-dlp... |
| Documents | pandoc, ocrmypdf, tesseract... |
| AI Tools | gemini-cli |
| Fun & Games | cowsay, figlet, fortune, sl... |
| Databases | mysql, postgresql, pgcli |

### Fase 8: Applicazioni (Cask)
| Categoria | App |
|-----------|-----|
| Browsers | Chrome, Firefox, Brave, Tor |
| Dev | VS Code, iTerm2, Docker Desktop, GitKraken |
| Productivity | Obsidian, Notion, Slack, Anki |
| Multimedia | VLC, Audacity, HandBrake, Calibre |
| Utilities | UTM, Cyberduck, CCleaner |
| Communication | WhatsApp, Discord, Zoom |
| Entertainment | Steam, Epic Games |

### Fase 9-10: Configurazioni (automatico)
- Lo script copia automaticamente .zshrc, .p10k.zsh, .fzf.zsh dalla cartella `configs/`
- Lo script importa automaticamente il profilo iTerm2
- Lo script configura automaticamente il secondo utente (se specificato)

## Personalizzazione

Apri `setup-mac.sh` con un editor e modifica i flag all'inizio:

```bash
# Imposta false per saltare una categoria
INSTALL_DEV_TOOLS=true
INSTALL_CLI_ESSENTIALS=true
INSTALL_FUN_GAMES=true        # false se non vuoi cowsay, sl, etc.
INSTALL_CASK_ENTERTAINMENT=true  # false se non vuoi Steam, Epic
# ... etc
```

## Dopo l'installazione

1. **Chiudi e riapri il terminale** (o esegui `source ~/.zshrc`)

2. **Configura font in iTerm2:**
   - Preferences → Profiles → Text → Font
   - Seleziona **MesloLGS NF**

3. **Powerlevel10k wizard:**
   - Al primo avvio ti chiederà di configurare il prompt
   - Le tue impostazioni precedenti sono già in `.p10k.zsh`

4. **Configura Cubbit (se lo usi):**
   ```bash
   aws configure --profile cubbit
   ```

## Log

Lo script salva un log in `~/setup-mac.log` per debug.

## Troubleshooting

### "Permission denied"
```bash
chmod +x setup-mac.sh
```

### Xcode CLI Tools non si installa
Aspetta che finisca il popup di installazione, poi riesegui lo script.

### Homebrew non trovato dopo installazione
Chiudi e riapri il terminale, oppure:
```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

---
*Generato il 19 Dicembre 2024*
