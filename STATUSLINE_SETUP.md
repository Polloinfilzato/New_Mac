# Claude Code Statusline - Configurazione Personalizzata

## Descrizione

Statusline personalizzata per Claude Code con le seguenti caratteristiche:

### Elementi visualizzati (da sinistra a destra)
1. **user@hostname** - colore verde (tema terminale)
2. **directory** - colore blu (tema terminale)
3. **git:(branch)** - informazioni git con:
   - Nome branch con colore RGB (indipendente dal tema):
     - **Verde RGB** (`#00C800`) se repo pulito
     - **Arancione RGB** (`#FFA500`) se ci sono modifiche
   - `*` se ci sono modifiche staged/unstaged
   - `+` se ci sono file untracked
   - `↑n` commit da pushare (ciano)
   - `↓n` commit da pullare (rosso)
4. **[modello]** - nome modello Claude (grigio)
5. **HH:MM:SS** - orario allineato a destra (arancione tema)

### Esempio output
```
ema@MacBook progetto git:(master) [Opus 4.5]                    14:30:45
ema@MacBook progetto git:(feature*+) ↑2 [Sonnet 4]              14:30:45
```

## Installazione

### 1. Crea il file statusline.sh

```bash
mkdir -p ~/.claude
cat > ~/.claude/statusline.sh << 'SCRIPT'
#!/bin/bash
# Claude Code Status Line - Enhanced Version
# Features:
#   - Branch verde (RGB) se pulito, arancione (RGB) se ci sono modifiche
#   - ↑n per commit non pushati
#   - ↓n per commit da pullare
#   - * per modifiche locali non committate
#   - + per file untracked
#   - Orario allineato a destra

input=$(cat)
cwd=$(echo "$input" | jq -r ".workspace.current_dir")
model=$(echo "$input" | jq -r ".model.display_name")

user=$(whoami)
host=$(hostname -s)
dir=$(basename "$cwd")

# Colori ANSI standard (usano il tema del terminale)
GREEN=$'\033[32m'
ORANGE=$'\033[33m'
BLUE=$'\033[34m'
CYAN=$'\033[36m'
GRAY=$'\033[90m'
RED=$'\033[31m'
RESET=$'\033[0m'

# Colori RGB per git branch (indipendenti dal tema)
GIT_GREEN=$'\033[38;2;0;200;0m'
GIT_ORANGE=$'\033[38;2;255;165;0m'

git_info=""

if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$cwd" branch --show-current 2>/dev/null || echo "detached")

    # Check modifiche locali (staged + unstaged)
    has_changes=false
    has_untracked=false

    if ! git -C "$cwd" diff --quiet 2>/dev/null || ! git -C "$cwd" diff --cached --quiet 2>/dev/null; then
        has_changes=true
    fi

    # Check file untracked
    if [ -n "$(git -C "$cwd" ls-files --others --exclude-standard 2>/dev/null)" ]; then
        has_untracked=true
    fi

    # Determina colore branch (usa RGB per evitare rimappature tema)
    if [ "$has_changes" = true ] || [ "$has_untracked" = true ]; then
        branch_color="$GIT_ORANGE"
    else
        branch_color="$GIT_GREEN"
    fi

    # Indicatore modifiche
    changes=""
    if [ "$has_changes" = true ]; then
        changes="*"
    fi
    if [ "$has_untracked" = true ]; then
        changes="${changes}+"
    fi

    # Commit da pushare (ahead)
    ahead=$(git -C "$cwd" rev-list @{u}..HEAD 2>/dev/null | wc -l | tr -d " ")
    unpushed=""
    if [ "$ahead" -gt 0 ] 2>/dev/null; then
        unpushed=" ${CYAN}↑$ahead${RESET}"
    fi

    # Commit da pullare (behind)
    behind=$(git -C "$cwd" rev-list HEAD..@{u} 2>/dev/null | wc -l | tr -d " ")
    unpulled=""
    if [ "$behind" -gt 0 ] 2>/dev/null; then
        unpulled=" ${RED}↓$behind${RESET}"
    fi

    git_info=" git:(${branch_color}${branch}${changes}${RESET})${unpushed}${unpulled}"
fi

current_time=$(date +%H:%M:%S)

# Costruisci parte sinistra
left_part="${GREEN}${user}@${host}${RESET} ${BLUE}${dir}${RESET}${git_info} ${GRAY}[${model}]${RESET}"

# Parte destra (orario)
right_part="${ORANGE}${current_time}${RESET}"

# Funzione per rimuovere codici ANSI (inclusi RGB)
strip_ansi() {
    printf '%s' "$1" | sed $'s/\033\[[0-9;]*m//g'
}

# Calcola lunghezza senza codici ANSI
left_stripped=$(strip_ansi "$left_part")
right_stripped=$(strip_ansi "$right_part")
left_len=${#left_stripped}
right_len=${#right_stripped}

# Larghezza fissa (regola in base alla larghezza del tuo terminale)
term_width=105

# Calcola spazi per allineare a destra
padding=$((term_width - left_len - right_len))
if [ "$padding" -lt 1 ]; then
    padding=1
fi

# Output finale con padding spazi
printf "%s%*s%s\n" "$left_part" "$padding" "" "$right_part"
SCRIPT
chmod +x ~/.claude/statusline.sh
```

### 2. Configura Claude Code

Aggiungi al file `~/.claude/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh"
  }
}
```

Oppure esegui in Claude Code:
```
/statusline command ~/.claude/statusline.sh
```

### 3. Regola la larghezza

Modifica `term_width=105` nel file `~/.claude/statusline.sh` in base alla larghezza della tua finestra terminale.

## Requisiti

- `jq` installato (`brew install jq` su macOS)
- `git` per le informazioni repository

## Note tecniche

- I colori del branch git usano RGB (`\033[38;2;R;G;Bm`) per essere indipendenti dal tema del terminale
- Gli altri elementi usano colori ANSI standard che rispettano il tema del terminale
- L'allineamento a destra usa padding con spazi (evita escape di posizionamento cursore che causano bug con input multilinea)
