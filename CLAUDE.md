# Configurazione Narsil - Resoconto Fix e Setup

## Problema Principale: `zsh compinit: insecure directories`

All'avvio del terminale appariva l'errore:
```
zsh compinit: insecure directories, run compaudit for list.
Ignore insecure directories and continue [y] or abort compinit [n]?
```

### Causa
La configurazione multi-utente in `setup-narsil.sh` (FASE 3) imposta `chmod g+rwX` su tutto `/opt/homebrew` per permettere la condivisione Homebrew tra ema e ste. Questo rende le directory di completamento zsh "insicure" (scrivibili dal gruppo).

### Directory problematiche
```
/opt/homebrew/share/zsh
/opt/homebrew/share/zsh/site-functions
/opt/homebrew/Cellar/zsh-autocomplete/*/share/zsh-autocomplete
/opt/homebrew/Cellar/zsh-autocomplete/*/share/zsh-autocomplete/Completions
```

### Soluzione applicata
Rimosso il permesso di scrittura gruppo (`g-w`) solo dalle directory di completamento zsh, mantenendo `g+w` sul resto di Homebrew per la condivisione multi-utente:

```bash
chmod g-w /opt/homebrew/share/zsh /opt/homebrew/share/zsh/site-functions
chmod g-w /opt/homebrew/Cellar/zsh-autocomplete/*/share/zsh-autocomplete
chmod g-w /opt/homebrew/Cellar/zsh-autocomplete/*/share/zsh-autocomplete/Completions
```

### Aggiornamento setup-narsil.sh
Aggiunto fix automatico nella FASE 3 (dopo la configurazione multi-utente):
```bash
# Fix permessi zsh per evitare "compinit: insecure directories"
chmod g-w /opt/homebrew/share/zsh /opt/homebrew/share/zsh/site-functions 2>/dev/null || true
find /opt/homebrew/Cellar/zsh-autocomplete -type d -name "zsh-autocomplete" -exec chmod g-w {} \; 2>/dev/null || true
find /opt/homebrew/Cellar/zsh-autocomplete -type d -name "Completions" -exec chmod g-w {} \; 2>/dev/null || true
```

---

## Fix .zshrc

### 1. Aggiunto ZSH_DISABLE_COMPFIX
Prima di `source $ZSH/oh-my-zsh.sh`:
```bash
ZSH_DISABLE_COMPFIX=true
```

### 2. Rimossi plugin duplicati
I plugin `zsh-autosuggestions` e `zsh-syntax-highlighting` erano elencati sia nella lista `plugins=()` di oh-my-zsh (dove non venivano trovati) sia caricati via `source` da Homebrew (dove funzionano).

**Rimossi dalla lista plugins:**
```bash
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
```

I plugin continuano a funzionare tramite le righe source esistenti.

### 3. Rimosso compinit duplicato
Rimosso il blocco ridondante (oh-my-zsh già gestisce compinit):
```bash
# RIMOSSO:
autoload -Uz compinit
compinit
```

---

## Fix .fzf.zsh - Path Apple Silicon

Il file `.fzf.zsh` aveva path Intel (`/usr/local/opt/fzf/`) invece di Apple Silicon.

**Prima:**
```bash
PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
source "/usr/local/opt/fzf/shell/completion.zsh"
source "/usr/local/opt/fzf/shell/key-bindings.zsh"
```

**Dopo:**
```bash
PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
source "/opt/homebrew/opt/fzf/shell/completion.zsh"
source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"
```

---

## Fix HostName

Fastfetch mostrava "ema@Mac" invece di "ema@Narsil".

**Problema:** `HostName` non era impostato (solo `ComputerName` e `LocalHostName` lo erano).

**Fix:**
```bash
sudo scutil --set HostName Narsil
```

---

## Configurazione fastfetch

Creata configurazione in `~/.config/fastfetch/config.jsonc`.

**Rimossi:**
- `colors` (palette colori in fondo)
- `cursor`
- `swap`

---

## Comandi per propagare i fix a ste

### Copiare .zshrc e .fzf.zsh
```bash
sudo cp /Users/ema/.zshrc /Users/ema/.fzf.zsh /Users/ste/
sudo chown ste:staff /Users/ste/.zshrc /Users/ste/.fzf.zsh
```

### Copiare configurazione fastfetch
```bash
sudo mkdir -p /Users/ste/.config/fastfetch
sudo cp ~/.config/fastfetch/config.jsonc /Users/ste/.config/fastfetch/
sudo chown -R ste:staff /Users/ste/.config/fastfetch
```

### Fix permessi directory zsh (da eseguire una sola volta)
```bash
chmod g-w /opt/homebrew/share/zsh /opt/homebrew/share/zsh/site-functions
find /opt/homebrew/Cellar/zsh-autocomplete -type d -name "zsh-autocomplete" -exec chmod g-w {} \; 2>/dev/null
find /opt/homebrew/Cellar/zsh-autocomplete -type d -name "Completions" -exec chmod g-w {} \; 2>/dev/null
```

### Impostare HostName (se non già fatto)
```bash
sudo scutil --set HostName Narsil
```

---

## Riepilogo file modificati

| File | Modifica |
|------|----------|
| `~/.zshrc` | ZSH_DISABLE_COMPFIX, rimossi plugin duplicati |
| `~/.fzf.zsh` | Path corretti per Apple Silicon |
| `~/.config/fastfetch/config.jsonc` | Rimossi colors, cursor, swap |
| `configs/.zshrc` | Stesse modifiche (sorgente per future installazioni) |
| `configs/.fzf.zsh` | Stesse modifiche |
| `setup-narsil.sh` | Aggiunto fix permessi zsh nella FASE 3 |

---

## Checklist per ste

- [x] Copiare .zshrc e .fzf.zsh da ema
- [x] Copiare config fastfetch
- [x] Verificare che oh-my-zsh sia installato (`~/.oh-my-zsh`)
- [x] Verificare che powerlevel10k sia installato (`~/.oh-my-zsh/custom/themes/powerlevel10k`)
- [x] Verificare che `.p10k.zsh` esista in home
- [x] Aprire nuovo terminale e verificare assenza errori

---

## Fix eseguiti da ste (21 dicembre 2024)

### Problema 1: Permessi Homebrew multi-utente incompleti

Nonostante ste fosse nel gruppo `brew`, non riusciva a installare pacchetti. Errori:
```
Error: Permission denied @ apply2files - /opt/homebrew/Caches/api/cask.jws.json
Error: The following directories are not writable by your user: /opt/homebrew/share/zsh
```

**Causa:** I permessi di gruppo non erano impostati correttamente su tutti i file, e mancava il setgid bit sulle directory.

**Fix applicato:**
```bash
sudo chown -R :brew /opt/homebrew
sudo chmod -R g+rwX /opt/homebrew
sudo find /opt/homebrew -type d -exec chmod g+s {} \;
```

Il setgid bit (`chmod g+s`) è fondamentale: fa sì che i nuovi file creati ereditino il gruppo `brew` invece del gruppo primario dell'utente.

---

### Problema 2: Warning compinit persistente

Anche dopo i fix precedenti, il warning appariva ancora perché non tutte le directory zsh erano state corrette.

**Fix applicato:**
```bash
sudo find /opt/homebrew -type d -name "*zsh*" -exec chmod g-w {} \;
sudo find /opt/homebrew -type d -name "site-functions" -exec chmod g-w {} \;
rm -f ~/.zcompdump*
```

---

### Problema 3: Oh-My-Zsh incompleto per ste

L'installazione con `sudo -u ste` dalla sessione di ema era fallita silenziosamente. La directory `~/.oh-my-zsh` conteneva solo 1 elemento invece di 14.

**Fix applicato:**
```bash
rm -rf ~/.oh-my-zsh
RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
```

---

### Problema 4: Powerlevel10k mancante

Powerlevel10k non era installato per ste. Invece di clonarlo (duplicando), creato symlink alla versione brew:

**Fix applicato:**
```bash
mkdir -p ~/.oh-my-zsh/custom/themes
ln -sf /opt/homebrew/share/powerlevel10k ~/.oh-my-zsh/custom/themes/powerlevel10k
```

---

### Problema 5: zsh-autocomplete causa errori

Quando si premeva freccia su o Tab, apparivano errori:
```
zsh: command not found: _autocomplete__history_lines
zsh: command not found: _autocomplete__unambiguous
```

**Causa:** zsh-autocomplete ha conflitti noti con oh-my-zsh.

**Fix applicato:** Disabilitato in `.zshrc`:
```bash
# DISABILITATO - conflitto con oh-my-zsh, causa errori autocomplete
# [ -f "$BREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh" ] && \
#   source "$BREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
```

I plugin `zsh-autosuggestions` e `zsh-syntax-highlighting` continuano a funzionare correttamente.

---

## Aggiornamenti a setup-narsil.sh (post-fix ste)

### FASE 3 - Migliorato fix permessi multi-utente

1. Aggiunto `sudo find /opt/homebrew -type d -exec chmod g+s {} \;` per setgid su TUTTE le directory
2. Fix compinit ora copre TUTTE le directory zsh: `sudo find /opt/homebrew -type d -name "*zsh*" -exec chmod g-w {} \;`

### FASE 10 - Migliorata configurazione secondo utente

1. Oh-My-Zsh: aggiunto warning che l'installazione con sudo -u può fallire
2. Powerlevel10k: ora usa symlink a brew invece di clone
3. Aggiunta copia di `.fzf.zsh` e `fastfetch/config.jsonc`
4. Aggiunta creazione `.zshenv` con `skip_global_compinit=1`

---

### Problema 6: Fastfetch glitch grafico al primo avvio

Quando si apriva il primo terminale, l'ASCII art della mela era corrotta con testo che appariva nelle righe sbagliate.

**Causa:** L'instant prompt di Powerlevel10k (`POWERLEVEL9K_INSTANT_PROMPT=quiet`) interferisce con l'output di fastfetch.

**Fix applicato:** Disabilitato instant prompt in `.zshrc`:
```bash
# Prima:
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# Dopo:
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
```

**Nota:** L'instant prompt velocizza l'avvio del terminale mostrando il prompt immediatamente, ma causa conflitti con programmi che stampano output all'avvio (come fastfetch). Disabilitandolo, l'avvio è leggermente più lento ma senza glitch.

---

### Problema 7: Permessi persistenti - ACL per Homebrew multi-utente

Nonostante setgid e chmod g+rwX, ste continuava ad avere problemi di scrittura su alcuni file perché la **umask** di default (022) crea file senza `g+w`.

**Fix definitivo con ACL:**
```bash
sudo chmod -R +a "group:brew allow list,add_file,search,add_subdirectory,delete_child,readattr,writeattr,readextattr,writeextattr,readsecurity,file_inherit,directory_inherit" /opt/homebrew
```

**Cosa fa l'ACL:**
- `file_inherit,directory_inherit` = i nuovi file/cartelle ereditano automaticamente i permessi
- Indipendente dalla umask dell'utente
- Permanente e automatico

**Verifica ACL:**
```bash
ls -le /opt/homebrew/Caches/api/ | head -3
```

---

## Lezioni apprese

1. **Setgid bit è essenziale** per multi-utente Homebrew - senza di esso i nuovi file non ereditano il gruppo corretto
2. **`sudo -u` per installare oh-my-zsh** può fallire silenziosamente - meglio che l'utente lo faccia dalla propria sessione
3. **zsh-autocomplete** non è compatibile con oh-my-zsh - disabilitarlo se causa problemi
4. **Symlink per powerlevel10k** è meglio di clonare - evita duplicati e usa la versione gestita da brew
5. **Instant prompt P10k** interferisce con fastfetch - disabilitare con `POWERLEVEL9K_INSTANT_PROMPT=off`
6. **ACL con ereditarietà** è la soluzione definitiva per multi-utente - supera i limiti di umask e garantisce permessi corretti su tutti i nuovi file
