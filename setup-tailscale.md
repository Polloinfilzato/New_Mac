# Setup Tailscale - Guida rapida

## 1. Installa
```bash
brew install tailscale
```

## 2. Avvia daemon (con sudo, una volta sola)
```bash
sudo brew services start tailscale
```

## 3. Imposta hostname di sistema
```bash
sudo scutil --set ComputerName NomeMac
sudo scutil --set LocalHostName NomeMac
sudo scutil --set HostName NomeMac
```

## 4. Login (apre browser)
```bash
tailscale up
```

## 5. Imposta hostname Tailscale
```bash
tailscale set --hostname nomemac
```

## 6. Verifica
```bash
tailscale status
hostname
```

## 7. Configura DNS per MagicDNS

> **Nota:** Questo passaggio è necessario con l'installazione CLI (`brew install tailscale`).
> L'app GUI (`brew install --cask tailscale`) configura il DNS automaticamente.

**Importante:** Per risolvere i nomi Tailscale (es. `narsil`, `waneda`) devi aggiungere il DNS Tailscale manualmente.

**Da GUI:**
> Impostazioni > Rete > Wi-Fi > Dettagli > DNS > Aggiungi: `100.100.100.100`

**Da terminale:**
```bash
# Mostra interfaccia attiva
networksetup -listallnetworkservices

# Aggiungi DNS Tailscale (sostituisci "Wi-Fi" con la tua interfaccia)
sudo networksetup -setdnsservers "Wi-Fi" 100.100.100.100

# Verifica
networksetup -getdnsservers "Wi-Fi"

# Flush cache DNS
sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
```

Fallo su **entrambi i Mac**.

---

## 8. Abilita SSH sul Mac

**Opzione A - Da GUI:**
> Impostazioni > Generali > Condivisione > Login remoto: ON

**Opzione B - Da terminale (metodo diretto):**
```bash
sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist
```

**Opzione C - Da terminale (systemsetup):**
```bash
sudo systemsetup -setremotelogin on
```

*Se dà errore "Full Disk Access privileges", prima esegui:*
```bash
# Apri le preferenze Privacy
open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
```
> Poi aggiungi Terminale/iTerm2 a Full Disk Access

**Verifica:**
```bash
sudo systemsetup -getremotelogin
# oppure
sudo launchctl list | grep ssh
```

---

## Comandi utili

| Comando | Descrizione |
|---------|-------------|
| `tailscale status` | Mostra dispositivi connessi |
| `tailscale up` | Connetti alla rete |
| `tailscale down` | Disconnetti (daemon resta attivo) |
| `sudo brew services stop tailscale` | Ferma daemon |
| `ssh utente@nome-mac` | Connetti via SSH |
| `scp file utente@nome-mac:~/` | Copia file |
| `rsync -avz cartella/ utente@nome-mac:~/` | Sincronizza cartella |

---

## Esempi pratici (Waneda ↔ Narsil)

### SSH - Accesso remoto
```bash
# Da Waneda, accedi a Narsil
ssh ema@narsil

# Da Narsil, accedi a Waneda
ssh ema@waneda

# Esegui comando singolo senza aprire shell
ssh ema@narsil "ls -la ~/Documents"
```

### SCP - Copia file
```bash
# Copia file da Waneda a Narsil
scp documento.pdf ema@narsil:~/Documents/

# Copia file da Narsil a Waneda (eseguito da Waneda)
scp ema@narsil:~/Documents/foto.jpg ~/Downloads/

# Copia cartella intera (flag -r)
scp -r ~/Progetti/app ema@narsil:~/Progetti/
```

### rsync - Sincronizzazione
```bash
# Sincronizza cartella da Waneda a Narsil
rsync -avz ~/Progetti/ ema@narsil:~/Progetti/

# Sincronizza da Narsil a Waneda (eseguito da Waneda)
rsync -avz ema@narsil:~/Foto/ ~/Foto/

# Sync con cancellazione file non più presenti nella sorgente
rsync -avz --delete ~/Progetti/ ema@narsil:~/Progetti/

# Dry-run (mostra cosa farebbe senza eseguire)
rsync -avzn ~/Progetti/ ema@narsil:~/Progetti/
```

**Flag rsync:**
| Flag | Significato |
|------|-------------|
| `-a` | Archive (preserva permessi, date, etc.) |
| `-v` | Verbose (mostra progresso) |
| `-z` | Comprimi durante trasferimento |
| `-n` | Dry-run (simula senza eseguire) |
| `--delete` | Elimina file nella destinazione non presenti nella sorgente |

---

## Troubleshooting

### Errore "Operation not permitted" su cartelle iCloud

Se via SSH non riesci ad accedere a `~/Library/Mobile Documents/` (iCloud Drive):

```
ls: .: Operation not permitted
EPERM: operation not permitted, lstat '/Users/ema/Library/Mobile Documents'
```

**Causa:** macOS protegge la cartella iCloud. I processi SSH non hanno Full Disk Access.

**Soluzione:**
```bash
# Apri le preferenze Full Disk Access
open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
```

Poi manualmente:
1. Clicca `+`
2. Premi `Cmd+Shift+G`
3. Vai a: `/usr/libexec/sshd-keygen-wrapper`
4. Aggiungilo e attivalo

> **Nota:** Non esiste comando terminale per questo - è una protezione di sicurezza macOS.

### Errore "max file descriptors" con Claude via SSH

Se Claude dà errore sui file descriptors via SSH:

```
error: An unknown error occurred, possibly due to low max file descriptors
Current limit: 256
```

**Soluzione:** Aggiungi al `~/.zshrc` del Mac remoto:
```bash
ulimit -n 2147483646
```
