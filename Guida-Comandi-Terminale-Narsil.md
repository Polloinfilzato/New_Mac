# ⚔️ Guida Comandi Terminale - Setup Narsil

> *"La spada che fu spezzata, riforgiata per il tuo Mac"*

Questa guida documenta tutti i comandi installati tramite lo script **Setup Narsil** per MacBook Air M4. Ogni comando include una descrizione, le flag più utili e esempi pratici.

---

## 🛠️ Manutenzione Sistema

### `fixbrew`
Ripristina istantaneamente i permessi di Homebrew per il setup multi-utente (`ema` + `ste`). Da usare in caso di errori "Permission denied" o problemi di permessi dopo aggiornamenti di brew.

```bash
sudo fixbrew                # Ripristina permessi, ACL e bit di esecuzione
```

---

## 📑 Indice

- [[#🛠️ Manutenzione Sistema]]

### Formule CLI
- [[#🔧 Dev Tools]]
- [[#⚡ CLI Essentials]]
- [[#🖥️ Terminal & Shell]]
- [[#🌐 Networking]]
- [[#🎬 Multimedia]]
- [[#📄 Documents]]
- [[#🤖 AI Tools]]
- [[#🎮 Fun & Games]]
- [[#🗄️ Databases]]

### Applicazioni (Cask)
- [[#🌍 Browsers]]
- [[#💻 Development]]
- [[#📊 Productivity]]
- [[#🎥 Multimedia Apps]]
- [[#🛠️ Utilities]]
- [[#💬 Communication]]
- [[#🎯 Entertainment]]

---

# Formule CLI

---

## 🔧 Dev Tools

### `git`
Sistema di controllo versione distribuito.

```bash
# Comandi base
git init                    # Inizializza repository
git clone <url>             # Clona repository remoto
git status                  # Stato dei file
git add .                   # Aggiungi tutti i file
git add -p                  # Aggiungi interattivamente (patch mode)
git commit -m "messaggio"   # Commit con messaggio
git commit -am "msg"        # Add + commit file tracciati

# Branch
git branch                  # Lista branch
git branch <nome>           # Crea branch
git checkout <branch>       # Cambia branch
git checkout -b <nome>      # Crea e cambia branch
git merge <branch>          # Merge branch

# Remoti
git push                    # Push al remote
git push -u origin main     # Push e imposta upstream
git pull                    # Pull dal remote
git fetch                   # Scarica senza merge

# Cronologia
git log                     # Log completo
git log --oneline           # Log compatto
git log --graph             # Log con grafico
git diff                    # Differenze non staged
git diff --staged           # Differenze staged
```

---

### `gh`
GitHub CLI ufficiale - gestisci GitHub dal terminale.

```bash
# Autenticazione
gh auth login               # Login a GitHub
gh auth status              # Verifica stato auth

# Repository
gh repo create              # Crea nuovo repo
gh repo clone <repo>        # Clona repository
gh repo view                # Info sul repo corrente
gh repo fork                # Fork di un repo

# Pull Request
gh pr create                # Crea PR
gh pr list                  # Lista PR
gh pr checkout <numero>     # Checkout PR locale
gh pr merge                 # Merge PR
gh pr view                  # Visualizza PR corrente

# Issues
gh issue create             # Crea issue
gh issue list               # Lista issues
gh issue view <numero>      # Visualizza issue

# Actions
gh run list                 # Lista workflow runs
gh run view                 # Dettagli run
gh run watch                # Watch run in corso

# Gist
gh gist create <file>       # Crea gist
gh gist list                # Lista gist
```

---

### `glab`
GitLab CLI - come `gh` ma per GitLab.

```bash
glab auth login             # Login GitLab
glab repo clone <repo>      # Clona repo
glab mr create              # Crea Merge Request
glab mr list                # Lista MR
glab issue create           # Crea issue
glab ci view                # Visualizza pipeline CI
```

---

### `lazygit`
Interfaccia TUI per Git - gestione visuale.

```bash
lazygit                     # Apri interfaccia
# Navigazione con frecce, invio per azioni
# ? per help contestuale
# q per uscire
```

**Scorciatoie principali:**
- `space` - Stage/unstage file
- `c` - Commit
- `p` - Push
- `P` - Pull
- `b` - Branch menu
- `m` - Merge

---

### `gitup`
Visualizzatore grafico della storia Git.

```bash
gitup                       # Apri GUI (solo macOS)
```

---

### `hub`
Wrapper Git con funzioni GitHub extra (legacy, preferisci `gh`).

```bash
hub create                  # Crea repo su GitHub
hub fork                    # Fork repo
hub pull-request            # Crea PR
hub browse                  # Apri repo nel browser
```

---

### `delta`
Pager per diff Git con syntax highlighting.

```bash
# Configurazione in ~/.gitconfig:
# [core]
#     pager = delta
# [interactive]
#     diffFilter = delta --color-only

git diff                    # Ora usa delta automaticamente
delta file1 file2           # Diff tra due file
git show | delta            # Pipe a delta
```

**Flag utili:**
- `--side-by-side` o `-s` - Vista affiancata
- `--line-numbers` o `-n` - Mostra numeri linea
- `--navigate` - Naviga tra file con n/N

---

### `difftastic`
Diff strutturale che capisce la sintassi del codice.

```bash
difft file1.py file2.py     # Diff tra file
GIT_EXTERNAL_DIFF=difft git diff  # Usa con git

# Configurazione permanente in ~/.gitconfig:
# [diff]
#     external = difft
```

---

### `node`
Runtime JavaScript.

```bash
node                        # REPL interattivo
node script.js              # Esegui script
node -e "console.log(1+1)"  # Esegui codice inline
node --version              # Versione
```

---

### `nvm`
Node Version Manager - gestisci versioni Node.

```bash
nvm install 20              # Installa Node 20
nvm install --lts           # Installa ultima LTS
nvm use 20                  # Usa Node 20
nvm list                    # Lista versioni installate
nvm alias default 20        # Imposta default
nvm current                 # Versione attuale
```

---

### `npm` (incluso con node)
Package manager per Node.js.

```bash
npm init                    # Inizializza progetto
npm init -y                 # Init con defaults
npm install <pkg>           # Installa pacchetto
npm install -g <pkg>        # Installa globale
npm install -D <pkg>        # Installa dev dependency
npm update                  # Aggiorna pacchetti
npm run <script>            # Esegui script da package.json
npm list                    # Lista dipendenze
npm list -g                 # Lista globali
```

---

### `docker`
Containerizzazione applicazioni.

```bash
# Immagini
docker pull <image>         # Scarica immagine
docker images               # Lista immagini
docker rmi <image>          # Rimuovi immagine

# Container
docker run <image>          # Esegui container
docker run -it <image> bash # Interattivo con shell
docker run -d <image>       # Detached (background)
docker run -p 8080:80 <img> # Port mapping
docker run -v /host:/cont   # Volume mount
docker ps                   # Container attivi
docker ps -a                # Tutti i container
docker stop <id>            # Ferma container
docker rm <id>              # Rimuovi container
docker logs <id>            # Log container
docker exec -it <id> bash   # Shell in container attivo

# Cleanup
docker system prune         # Pulisci risorse inutilizzate
docker system prune -a      # Pulisci tutto (anche immagini)
```

---

### `docker-compose`
Orchestrazione multi-container.

```bash
docker-compose up           # Avvia servizi
docker-compose up -d        # Avvia in background
docker-compose down         # Ferma e rimuovi
docker-compose ps           # Stato servizi
docker-compose logs         # Log di tutti i servizi
docker-compose logs -f      # Log in tempo reale
docker-compose build        # Ricostruisci immagini
docker-compose restart      # Riavvia servizi
```

---

### `act`
Esegui GitHub Actions in locale.

```bash
act                         # Esegui workflow default
act -l                      # Lista jobs disponibili
act -j <job>                # Esegui job specifico
act push                    # Simula evento push
act pull_request            # Simula evento PR
act -n                      # Dry run (mostra cosa farebbe)
```

---

## ⚡ CLI Essentials

### `fzf`
Fuzzy finder interattivo - cerca qualsiasi cosa.

```bash
# Uso base
fzf                         # Cerca tra file
cat file | fzf              # Cerca in output
history | fzf               # Cerca nella history

# Integrazione shell (dopo setup)
Ctrl+R                      # Cerca history
Ctrl+T                      # Cerca file
Alt+C                       # Cambia directory

# Con altri comandi
vim $(fzf)                  # Apri file trovato in vim
cd $(find . -type d | fzf)  # cd in directory trovata
kill -9 $(ps aux | fzf | awk '{print $2}')  # Kill processo
```

**Flag utili:**
- `-m` - Selezione multipla (Tab per selezionare)
- `--preview 'cat {}'` - Anteprima file
- `-i` - Case insensitive (default)
- `-e` - Exact match

---

### `bat`
`cat` con syntax highlighting e numeri di linea.

```bash
bat file.py                 # Visualizza con highlight
bat -n file.py              # Solo numeri linea
bat -A file.txt             # Mostra caratteri invisibili
bat --style=plain file      # Senza decorazioni
bat -l python script        # Forza linguaggio
bat file1 file2             # Più file concatenati
bat --diff file1 file2      # Diff tra file

# Come pager per man
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
```

**Flag utili:**
- `-n` o `--number` - Numeri di linea
- `-A` o `--show-all` - Caratteri invisibili
- `-p` o `--plain` - Output pulito
- `--style=numbers,grid` - Stile personalizzato
- `-r 10:20` - Solo righe 10-20

---

### `eza`
`ls` moderno con icone e colori (ex `exa`).

```bash
eza                         # Lista base
eza -l                      # Lista lunga
eza -la                     # Includi nascosti
eza -lah                    # Con dimensioni leggibili
eza --tree                  # Vista albero
eza --tree -L 2             # Albero 2 livelli
eza -l --git                # Stato git per file
eza --icons                 # Con icone (richiede font Nerd)
eza -s modified             # Ordina per modifica
eza -s size                 # Ordina per dimensione

# Alias consigliati
alias ls='eza --icons'
alias ll='eza -lah --icons'
alias tree='eza --tree --icons'
```

**Flag utili:**
- `-l` - Lista lunga
- `-a` - Mostra nascosti
- `-h` - Dimensioni leggibili
- `--icons` - Mostra icone
- `--git` - Info git
- `-s` - Ordina (name, size, modified, etc.)
- `--tree` - Vista albero
- `-L <n>` - Profondità albero

---

### `ripgrep` (`rg`)
Grep ultrarapido per codice.

```bash
rg "pattern"                # Cerca in directory corrente
rg -i "pattern"             # Case insensitive
rg -w "word"                # Solo parole intere
rg -l "pattern"             # Solo nomi file
rg -c "pattern"             # Conta occorrenze
rg "pattern" -t py          # Solo file Python
rg "pattern" -g "*.js"      # Solo file .js
rg "pattern" -g "!*.min.js" # Escludi file
rg -A 3 "pattern"           # 3 righe dopo
rg -B 3 "pattern"           # 3 righe prima
rg -C 3 "pattern"           # 3 righe contesto
rg --hidden "pattern"       # Includi file nascosti
rg -F "literal string"      # Stringa letterale (no regex)

# Cerca e sostituisci (con sed)
rg -l "old" | xargs sed -i 's/old/new/g'
```

**Flag utili:**
- `-i` - Case insensitive
- `-w` - Parole intere
- `-l` - Solo nomi file
- `-c` - Conta match
- `-t <tipo>` - Filtra per tipo file
- `-g <glob>` - Filtra per pattern
- `-A/B/C <n>` - Contesto
- `--hidden` - File nascosti
- `-F` - Fixed string (no regex)

---

### `fd`
`find` moderno e veloce.

```bash
fd                          # Lista tutti i file
fd "pattern"                # Cerca per nome
fd -e py                    # Solo file .py
fd -e py -x wc -l           # Esegui comando su risultati
fd -t d                     # Solo directory
fd -t f                     # Solo file
fd -H                       # Includi nascosti
fd -I                       # Non rispettare .gitignore
fd -d 2                     # Profondità max 2
fd "pattern" /path          # Cerca in path specifico
fd -E node_modules          # Escludi directory

# Esempi pratici
fd -e json -x cat {}        # Cat tutti i JSON
fd -t f -0 | xargs -0 wc -l # Conta righe tutti i file
```

**Flag utili:**
- `-e <ext>` - Estensione file
- `-t f/d/l` - Tipo (file/dir/link)
- `-H` - File nascosti
- `-d <n>` - Profondità massima
- `-E <pattern>` - Escludi
- `-x <cmd>` - Esegui comando
- `-0` - Output null-separated

---

### `tldr`
Man pages semplificate con esempi pratici.

```bash
tldr tar                    # Esempi per tar
tldr git commit             # Esempi per git commit
tldr --update               # Aggiorna database
tldr --list                 # Lista tutti i comandi
```

---

### `zoxide`
`cd` intelligente che ricorda le directory visitate.

```bash
# Dopo prima configurazione, usa 'z' invece di 'cd'
z projects                  # Vai a directory che matcha "projects"
z pro                       # Fuzzy match
z ~/Documents               # Path esatto (come cd)
zi                          # Selezione interattiva con fzf

# Query
z -l                        # Lista directory note
z -l foo                    # Lista directory che matchano

# Aggiungi al .zshrc:
# eval "$(zoxide init zsh)"
```

---

### `htop`
Monitor processi interattivo.

```bash
htop                        # Apri monitor
# F1 - Help
# F2 - Setup
# F3 - Cerca
# F4 - Filtra
# F5 - Tree view
# F6 - Ordina
# F9 - Kill
# F10 - Esci
# u - Filtra per utente
# / - Cerca processo
```

---

### `bottom` (`btm`)
Monitor sistema moderno con grafici.

```bash
btm                         # Apri monitor
# Tab - Cambia widget
# ? - Help
# q - Esci
# e - Espandi widget
# / - Cerca processo
# dd - Kill processo
```

---

### `procs`
`ps` moderno con output colorato.

```bash
procs                       # Lista processi
procs --tree                # Vista albero
procs -w                    # Watch mode
procs <pid>                 # Info su PID specifico
procs --sortd cpu           # Ordina per CPU desc
procs --sortd mem           # Ordina per memoria desc
procs -a                    # Mostra tutti i processi
```

---

### `tree`
Visualizza struttura directory ad albero.

```bash
tree                        # Albero corrente
tree -L 2                   # Max 2 livelli
tree -d                     # Solo directory
tree -a                     # Includi nascosti
tree -I "node_modules"      # Escludi pattern
tree -h                     # Dimensioni leggibili
tree -P "*.py"              # Solo file che matchano
tree --dirsfirst            # Directory prima
```

---

### `watch`
Esegui comando periodicamente.

```bash
watch df -h                 # Spazio disco ogni 2s
watch -n 5 'ls -la'         # Ogni 5 secondi
watch -d 'date'             # Evidenzia differenze
watch -g 'command'          # Esci quando output cambia
watch --color 'eza -l'      # Preserva colori
```

---

### `dust`
Disk usage visuale (alternativa a `du`).

```bash
dust                        # Uso disco directory corrente
dust -d 2                   # Profondità 2
dust -r                     # Ordine inverso
dust -n 10                  # Top 10
dust /path                  # Directory specifica
dust -b                     # No percentuali
```

---

### `duf`
Disk usage per filesystem (alternativa a `df`).

```bash
duf                         # Tutti i filesystem
duf /                       # Solo root
duf --only local            # Solo dischi locali
duf --hide special          # Nascondi speciali
duf --json                  # Output JSON
```

---

### `broot`
File manager interattivo con fuzzy search.

```bash
broot                       # Apri file manager
br                          # Alias (dopo setup)
# :q - Esci
# :e - Edit file
# :cp <dest> - Copia
# :mv <dest> - Sposta
# / - Cerca
# Tab - Seleziona multipli
```

---

### `ranger`
File manager TUI stile Vim.

```bash
ranger                      # Apri file manager
# h,j,k,l - Navigazione
# q - Esci
# yy - Copia
# dd - Taglia
# pp - Incolla
# / - Cerca
# zh - Toggle nascosti
# S - Apri shell
```

---

### `glow`
Renderer Markdown nel terminale.

```bash
glow README.md              # Visualizza file
glow -p README.md           # Con pager
glow -w 80 file.md          # Larghezza max 80
glow -s dark file.md        # Stile dark
cat file.md | glow -        # Da stdin
glow                        # Browser file .md
```

---

### `dos2unix`
Converti line endings DOS → Unix.

```bash
dos2unix file.txt           # Converti file
dos2unix -n in.txt out.txt  # Nuovo file
unix2dos file.txt           # Unix → DOS
```

---

### `fastfetch`
System info veloce e configurabile.

```bash
fastfetch                   # Info sistema
fastfetch -c all            # Tutte le info
fastfetch --gen-config      # Genera config
```

---

## 🖥️ Terminal & Shell

### `zsh-autosuggestions`
Suggerimenti automatici basati sulla history.

```text
# Plugin per Oh-My-Zsh
# Configurazione in .zshrc:
plugins=(... zsh-autosuggestions)

# → premi freccia destra per accettare suggerimento
```

---

### `zsh-autocomplete`
Completamento automatico avanzato.

```text
# Mostra completamenti mentre digiti
# Tab per navigare tra opzioni
```

---

### `zsh-syntax-highlighting`
Syntax highlighting per comandi shell.

```text
# Comandi validi = verde
# Comandi non validi = rosso
# Path esistenti = sottolineati
```

---

### `tmux`
Terminal multiplexer - sessioni persistenti.

```bash
tmux                        # Nuova sessione
tmux new -s nome            # Sessione con nome
tmux ls                     # Lista sessioni
tmux attach -t nome         # Riconnetti a sessione
tmux kill-session -t nome   # Termina sessione

# Comandi (prefisso Ctrl+b)
Ctrl+b c                    # Nuova finestra
Ctrl+b n                    # Finestra successiva
Ctrl+b p                    # Finestra precedente
Ctrl+b %                    # Split verticale
Ctrl+b "                    # Split orizzontale
Ctrl+b frecce               # Naviga pannelli
Ctrl+b d                    # Detach
Ctrl+b z                    # Zoom pannello
Ctrl+b x                    # Chiudi pannello
Ctrl+b [                    # Scroll mode (q per uscire)
```

---

### `thefuck`
Corregge automaticamente comandi errati.

```bash
# Dopo comando sbagliato, digita:
fuck                        # Suggerisce correzione

# O configura alias:
eval $(thefuck --alias)
# Poi usa il tasto definito (default: doppio ESC)
```

---

### `navi`
Cheatsheet interattivo nel terminale.

```bash
navi                        # Apri cheatsheet interattivo
navi --query docker         # Cerca comandi docker
navi --path /path/to/cheats # Usa cheatsheet custom
# Ctrl+G in shell per aprire (dopo setup)
```

---

## 🌐 Networking

### `wget`
Download file da web.

```bash
wget <url>                  # Download file
wget -O nome.zip <url>      # Salva con nome
wget -c <url>               # Continua download interrotto
wget -r <url>               # Download ricorsivo
wget -np -r <url>           # Ricorsivo senza parent
wget -i urls.txt            # Download da lista
wget -q <url>               # Quiet mode
wget --limit-rate=1m <url>  # Limita velocità
wget --user=u --password=p  # Con auth
```

**Flag utili:**
- `-O <file>` - Output file
- `-c` - Continue (riprendi)
- `-r` - Ricorsivo
- `-q` - Quiet
- `-b` - Background
- `--limit-rate=<n>` - Limita banda

---

### `httpie` (`http`)
Client HTTP user-friendly (alternativa a curl).

```bash
http GET example.com        # GET request
http POST api.com data=valore  # POST con JSON
http PUT api.com id=1       # PUT
http DELETE api.com/1       # DELETE
http -f POST api.com file=@data.txt  # Form data
http --download url         # Download file
http -v api.com             # Verbose
http api.com Authorization:"Bearer token"  # Header

# Output
http api.com | jq           # Pipe a jq
http --body api.com         # Solo body
http --headers api.com      # Solo headers
```

---

### `nmap`
Network scanner e security auditing.

```bash
nmap <host>                 # Scan porte comuni
nmap -p 22,80,443 <host>    # Porte specifiche
nmap -p- <host>             # Tutte le porte
nmap -sV <host>             # Versione servizi
nmap -O <host>              # OS detection
nmap -A <host>              # Scan aggressivo (OS+versioni+script)
nmap -sn 192.168.1.0/24     # Ping sweep (host discovery)
nmap --top-ports 100 <host> # Top 100 porte
```

⚠️ **Nota**: Usa solo su reti/host di tua proprietà o con permesso.

---

### `speedtest-cli`
Test velocità internet.

```bash
speedtest                   # Test completo
speedtest --simple          # Output semplice
speedtest --list            # Lista server
speedtest --server <id>     # Server specifico
speedtest --json            # Output JSON
```

---

### `telnet`
Client telnet per debug connessioni.

```bash
telnet <host> <porta>       # Connetti
# Ctrl+] per menu telnet
# quit per uscire
```

---

### `transmission-cli`
Client BitTorrent da linea di comando.

```bash
transmission-cli file.torrent  # Download torrent
transmission-remote -l         # Lista download
transmission-remote -a file.torrent  # Aggiungi torrent
transmission-remote -t 1 -r    # Rimuovi torrent
```

---

## 🎬 Multimedia

### `ffmpeg`
Toolkit multimediale - conversione e editing.

```bash
# Conversione
ffmpeg -i input.mp4 output.avi     # Converti formato
ffmpeg -i input.mp4 -c:v libx264 output.mp4  # Codec specifico
ffmpeg -i input.mp4 -crf 23 out.mp4  # Qualità (0-51, lower=better)

# Audio
ffmpeg -i video.mp4 -vn audio.mp3  # Estrai audio
ffmpeg -i video.mp4 -an silent.mp4 # Rimuovi audio
ffmpeg -i input.mp3 -b:a 192k out.mp3  # Bitrate audio

# Video
ffmpeg -i input.mp4 -ss 00:01:00 -t 00:00:30 clip.mp4  # Taglia
ffmpeg -i input.mp4 -vf scale=1280:720 out.mp4  # Resize
ffmpeg -i input.mp4 -r 30 out.mp4  # Framerate

# Immagini
ffmpeg -i video.mp4 -vf fps=1 img%04d.png  # Frame → immagini
ffmpeg -framerate 24 -i img%04d.png out.mp4  # Immagini → video

# Info
ffmpeg -i file.mp4           # Info sul file
ffprobe file.mp4             # Info dettagliate
```

---

### `imagemagick` (`convert`, `identify`, `mogrify`)
Manipolazione immagini da CLI.

```bash
# Conversione
convert input.png output.jpg      # Converti formato
convert input.png -quality 80 out.jpg  # Qualità JPEG

# Resize
convert input.png -resize 50% out.png  # Percentuale
convert input.png -resize 800x600 out.png  # Dimensioni
convert input.png -resize 800x600! out.png  # Forza dimensioni

# Effetti
convert input.png -rotate 90 out.png   # Ruota
convert input.png -flip out.png        # Flip verticale
convert input.png -flop out.png        # Flip orizzontale
convert input.png -grayscale average out.png  # Grayscale

# Batch (mogrify modifica in-place!)
mogrify -resize 800x600 *.png     # Resize tutti i PNG
mogrify -format jpg *.png         # Converti tutti a JPG

# Info
identify image.png                # Info base
identify -verbose image.png       # Info dettagliate
```

---

### `yt-dlp`
Download video da YouTube e altri siti.

```bash
yt-dlp <url>                     # Download video
yt-dlp -f best <url>             # Miglior qualità
yt-dlp -f "bestvideo+bestaudio" <url>  # Video+audio separati
yt-dlp -F <url>                  # Lista formati disponibili
yt-dlp -f 22 <url>               # Formato specifico
yt-dlp -x <url>                  # Solo audio
yt-dlp -x --audio-format mp3 <url>  # Audio MP3
yt-dlp --list-extractors         # Siti supportati
yt-dlp -o "%(title)s.%(ext)s" <url>  # Nome output custom
yt-dlp --download-archive done.txt <url>  # Evita duplicati

# Playlist
yt-dlp --playlist-items 1-10 <url>  # Solo primi 10
yt-dlp -I 1:10 <url>             # Alternativa
```

**Flag utili:**
- `-f` - Formato/qualità
- `-x` - Estrai audio
- `-o` - Output template
- `--sub-lang it` - Sottotitoli italiano
- `--write-subs` - Scarica sottotitoli

---

### `exiftool`
Leggi/scrivi metadati file.

```bash
exiftool photo.jpg           # Mostra tutti i metadati
exiftool -DateTimeOriginal photo.jpg  # Campo specifico
exiftool -all= photo.jpg     # Rimuovi tutti i metadati
exiftool -Artist="Nome" photo.jpg  # Imposta campo
exiftool -r -ext jpg .       # Ricorsivo su tutti i JPG
exiftool -json photo.jpg     # Output JSON
```

---

### `potrace`
Converti immagini bitmap in vettoriali.

```bash
potrace input.pbm -s -o out.svg   # PBM → SVG
potrace input.bmp -s -o out.svg   # BMP → SVG
potrace input.pbm -e -o out.eps   # → EPS
potrace input.pbm -p -o out.pdf   # → PDF
convert input.png input.pbm && potrace input.pbm -s  # PNG → SVG
```

---

### `handbrake` (CLI: `HandBrakeCLI`)
Transcodifica video.

```bash
HandBrakeCLI -i input.mp4 -o output.mkv  # Converti
HandBrakeCLI -i input.mp4 -o out.mp4 --preset="Fast 1080p30"
HandBrakeCLI --preset-list        # Lista preset
```

---

## 📄 Documents

### `pandoc`
Convertitore documenti universale.

```bash
# Markdown → altri formati
pandoc input.md -o output.pdf     # → PDF
pandoc input.md -o output.docx    # → Word
pandoc input.md -o output.html    # → HTML
pandoc input.md -o output.epub    # → EPUB

# Altri → Markdown
pandoc input.docx -o output.md    # Word → MD
pandoc input.html -o output.md    # HTML → MD

# Opzioni
pandoc input.md -o out.pdf --pdf-engine=xelatex  # Engine PDF
pandoc input.md -o out.pdf -V geometry:margin=1in  # Margini
pandoc -s input.md -o out.html    # Standalone (completo)
pandoc --toc input.md -o out.pdf  # Con indice
pandoc --template=t.tex input.md -o out.pdf  # Template custom
```

**Flag utili:**
- `-o` - Output file
- `-s` - Standalone
- `--toc` - Table of contents
- `-V <var>=<val>` - Variabili
- `--template` - Template custom
- `-f <formato>` - Formato input
- `-t <formato>` - Formato output

---

### `typst`
Sistema di typesetting moderno (alternativa a LaTeX).

```bash
typst compile document.typ        # Compila → PDF
typst compile doc.typ out.pdf     # Nome output
typst watch document.typ          # Watch mode
typst init                        # Nuovo progetto
typst fonts                       # Lista font disponibili
```

---

### `ocrmypdf`
OCR su PDF - rende PDF ricercabili.

```bash
ocrmypdf input.pdf output.pdf     # OCR base
ocrmypdf -l ita input.pdf out.pdf # Lingua italiana
ocrmypdf --skip-text in.pdf out.pdf  # Salta pagine già OCR
ocrmypdf --deskew in.pdf out.pdf  # Raddrizza pagine
ocrmypdf --rotate-pages in.pdf out.pdf  # Ruota automaticamente
ocrmypdf --optimize 3 in.pdf out.pdf  # Ottimizza dimensione
```

---

### `tesseract`
Motore OCR open source.

```bash
tesseract image.png output        # OCR → output.txt
tesseract image.png output -l ita # Italiano
tesseract image.png output pdf    # → PDF
tesseract image.png stdout        # Output a stdout
tesseract --list-langs            # Lingue disponibili
```

---

### `pdftk-java`
Toolkit PDF per manipolazione.

```bash
pdftk A=one.pdf B=two.pdf cat A B output merged.pdf  # Merge
pdftk input.pdf cat 1-5 output first5.pdf  # Estrai pagine
pdftk input.pdf cat 1-endeast output rotated.pdf  # Ruota
pdftk input.pdf burst                # Splitta in singole pagine
pdftk input.pdf dump_data            # Metadati
pdftk input.pdf output enc.pdf owner_pw pass user_pw pass  # Cripta
```

---

### `ghostscript` (`gs`)
Interprete PostScript e PDF.

```bash
# Comprimi PDF
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook \
   -dNOPAUSE -dQUIET -dBATCH -sOutputFile=out.pdf input.pdf

# -dPDFSETTINGS options:
# /screen   - 72 dpi, minima qualità
# /ebook    - 150 dpi, media qualità
# /printer  - 300 dpi, alta qualità
# /prepress - 300 dpi, massima qualità
```

---

### `img2pdf`
Converti immagini in PDF senza perdita qualità.

```bash
img2pdf *.jpg -o output.pdf       # Immagini → PDF
img2pdf --pagesize A4 *.jpg -o out.pdf  # Formato A4
img2pdf --imgsize 100mmx150mm *.jpg -o out.pdf
```

---

### `qrencode`
Genera QR code.

```bash
qrencode -o qr.png "https://example.com"  # URL → QR
qrencode -o qr.png -s 10 "text"   # Size 10 pixel
qrencode -t UTF8 "text"           # Output terminale
qrencode -t SVG -o qr.svg "text"  # → SVG
qrencode -l H "text" -o qr.png    # Alta correzione errori
```

---

## 🤖 AI Tools

### `gemini-cli`
CLI per Google Gemini.

```bash
gemini "Come funziona Python?"    # Domanda semplice
gemini -f file.txt "Riassumi"     # Con file
gemini -m gemini-pro "query"      # Modello specifico
```

---

### `aws-cli`
CLI per Amazon Web Services.

```bash
aws configure                     # Setup credenziali
aws s3 ls                         # Lista bucket S3
aws s3 cp file s3://bucket/       # Upload
aws s3 sync . s3://bucket/        # Sync directory
aws ec2 describe-instances        # Lista EC2
aws lambda list-functions         # Lista Lambda
```

---

### `copilot` (GitHub)
CLI per GitHub Copilot.

```bash
gh copilot suggest "how to list files"
gh copilot explain "ls -la"
```

---

### `ollama`
Esegui LLM in locale.

```bash
ollama run llama3                 # Chat con Llama 3
ollama run mistral                # Chat con Mistral
ollama run codellama              # Per coding
ollama list                       # Modelli installati
ollama pull llama3                # Scarica modello
ollama rm <model>                 # Rimuovi modello
ollama show llama3                # Info modello
ollama serve                      # Avvia server API

# API locale su http://localhost:11434
curl http://localhost:11434/api/generate -d '{
  "model": "llama3",
  "prompt": "Hello!"
}'
```

---

### `aichat`
Chat con LLM da terminale.

```bash
aichat                            # Chat interattiva
aichat "spiega Python"            # Domanda singola
aichat -f file.py "review code"   # Con file
aichat -m gpt-4 "query"           # Modello specifico
cat file | aichat "summarize"     # Pipe input
aichat -r translator "ciao"       # Usa ruolo predefinito
```

---

## 🎮 Fun & Games

### `cowsay`
Una mucca che parla.

```bash
cowsay "Hello!"                   # Mucca base
cowsay -f tux "Linux!"            # Pinguino
cowsay -l                         # Lista figure
fortune | cowsay                  # Con fortune
cowsay -d "Tired..."              # Mucca stanca
cowsay -s "Zzz..."                # Mucca che dorme
```

---

### `figlet`
ASCII art da testo.

```bash
figlet "Hello"                    # Testo → ASCII art
figlet -f banner "Hi"             # Font diverso
figlet -l                         # Lista font
figlet -c "Centered"              # Centrato
figlet -w 80 "text"               # Larghezza 80
```

---

### `fortune`
Citazioni casuali.

```bash
fortune                           # Citazione random
fortune -s                        # Solo corte
fortune -l                        # Solo lunghe
fortune | cowsay | lolcat         # Pipeline divertente
```

---

### `lolcat`
Output arcobaleno.

```bash
echo "Rainbow!" | lolcat          # Testo arcobaleno
ls -la | lolcat                   # Qualsiasi output
lolcat -a file.txt                # Animato
lolcat -t                         # Truecolor
```

---

### `toilet`
ASCII art con effetti.

```bash
toilet "Hello"                    # ASCII art
toilet -f mono12 "text"           # Font mono
toilet --metal "Metal"            # Effetto metal
toilet --gay "Rainbow"            # Arcobaleno
```

---

### `sl`
Steam Locomotive - punizione per typo `ls`.

```bash
sl                                # Treno che passa!
sl -l                             # Più lungo
sl -F                             # Vola
```

---

### `asciiquarium`
Acquario ASCII animato.

```bash
asciiquarium                      # Avvia acquario
# q per uscire
```

---

### `pipes-sh`
Screensaver con tubi.

```bash
pipes-sh                          # Avvia
# q per uscire
```

---

### `ninvaders`
Space Invaders nel terminale.

```bash
ninvaders                         # Gioca!
# Frecce per muoversi, Spazio per sparare
```

---

## 🗄️ Databases

### `mysql`
Client MySQL/MariaDB.

```bash
mysql -u root -p                  # Connetti come root
mysql -u user -p database         # Connetti a database
mysql -h host -u user -p          # Host remoto
mysql -e "SELECT * FROM table"    # Esegui query
mysql < dump.sql                  # Importa dump
mysqldump database > backup.sql   # Esporta dump
```

---

### `postgresql` (`psql`)
Client PostgreSQL.

```bash
psql                              # Connetti locale
psql -U user -d database          # User e database
psql -h host -U user -d db        # Host remoto
psql -c "SELECT * FROM table"     # Esegui query
psql -f script.sql                # Esegui file

# Comandi interni
\l                                # Lista database
\c database                       # Connetti a database
\dt                               # Lista tabelle
\d table                          # Descrivi tabella
\q                                # Esci
```

---

### `pgcli`
Client PostgreSQL con autocompletamento.

```bash
pgcli                             # Connetti
pgcli -h host -U user -d database # Con parametri
# Autocompletamento automatico!
# Syntax highlighting!
```

---

### `sqlite` (`sqlite3`)
Database SQLite.

```bash
sqlite3 database.db               # Apri/crea database
sqlite3 database.db "SELECT * FROM table"  # Query
sqlite3 database.db < script.sql  # Esegui script

# Comandi interni
.tables                           # Lista tabelle
.schema table                     # Schema tabella
.headers on                       # Mostra headers
.mode column                      # Formato colonne
.exit                             # Esci
```

---

# Applicazioni (Cask)

---

## 🌍 Browsers

### Google Chrome
Browser web principale. Avvia con `open -a "Google Chrome"` o da Spotlight/Raycast.

---

## 💻 Development

### Visual Studio Code
Editor di codice principale.

```bash
code .                            # Apri directory corrente
code file.py                      # Apri file
code --diff file1 file2           # Diff tra file
code --install-extension ext.id   # Installa estensione
code --list-extensions            # Lista estensioni
```

### Cursor
VS Code con AI integrata (Claude, GPT).

```bash
cursor .                          # Apri directory
cursor file.py                    # Apri file
# Cmd+K per generare codice con AI
# Cmd+L per chat con AI
```

### iTerm2
Terminale avanzato per macOS.

**Scorciatoie utili:**
- `Cmd+D` - Split verticale
- `Cmd+Shift+D` - Split orizzontale
- `Cmd+T` - Nuovo tab
- `Cmd+[/]` - Cambia pannello
- `Cmd+Enter` - Fullscreen

### Warp
Terminale moderno con AI.

**Features:**
- Completamento AI con `#`
- Blocchi di comandi
- Workflows condivisibili

### Docker Desktop
Gestione container Docker con GUI.

### GitHub Desktop
Client Git visuale.

### TablePlus
Client database universale (MySQL, PostgreSQL, SQLite, etc.).

### Claude
App desktop Claude AI.

### Claude Code
Coding assistant da terminale.

```bash
claude                            # Chat interattiva
claude -c "continua conversazione"
claude "spiega questo codice" < file.py
```

---

## 📊 Productivity

### Obsidian
Knowledge base e note in Markdown.

**Scorciatoie:**
- `Cmd+O` - Quick switcher
- `Cmd+P` - Command palette
- `Cmd+E` - Toggle edit/preview
- `[[` - Link interno

### Notion
Workspace all-in-one per note, wiki, progetti.

### Notion Calendar
Calendario integrato con Notion.

### Anki
Flashcard per memorizzazione.

### Raycast
Launcher potenziato che sostituisce Spotlight.

**Scorciatoie:**
- `Cmd+Space` (configurabile) - Apri Raycast
- Digita per cercare app, file, comandi
- Estensioni per GitHub, Jira, etc.

### Figma
Design UI/UX collaborativo.

---

## 🎥 Multimedia Apps

### VLC
Player multimediale universale.

```bash
vlc video.mp4                     # Apri video
vlc --fullscreen video.mp4        # Fullscreen
vlc --loop video.mp4              # Loop
```

### Audacity
Editor audio.

### HandBrake
Transcodifica video con GUI.

### Calibre
Gestione ebook e conversione formati.

### OBS Studio
Streaming e recording video.

### DaVinci Resolve
Editing video professionale (gratuito).

---

## 🛠️ Utilities

### UTM
Virtualizzazione per Mac (VM Windows, Linux, etc.).

### Cyberduck
Client FTP/SFTP/S3.

### Raspberry Pi Imager
Crea SD card per Raspberry Pi.

### MacFUSE + NTFSTool
Supporto lettura/scrittura dischi NTFS.

### Rectangle
Window manager con tastiera.

**Scorciatoie default:**
- `Ctrl+Opt+←` - Metà sinistra
- `Ctrl+Opt+→` - Metà destra
- `Ctrl+Opt+Enter` - Massimizza
- `Ctrl+Opt+C` - Centra

### Alt-Tab
Window switcher stile Windows.

**Scorciatoie:**
- `Opt+Tab` - Switcha finestre
- Mostra preview di tutte le finestre

### Stats
Monitor sistema nella menubar (CPU, RAM, rete, disco).

### AppCleaner
Disinstalla app completamente (rimuove tutti i file).

### Keka
Archiver (compressione/decompressione).

Supporta: ZIP, 7z, TAR, GZIP, BZIP2, XZ, LZIP, DMG, ISO, etc.

### Bartender
Organizza icone della menubar.

---

## 💬 Communication

### WhatsApp
Messaggistica.

### Discord
Chat per community e gaming.

### Zoom
Videoconferenze.

### Telegram
Messaggistica.

---

## 🎯 Entertainment

### Steam
Piattaforma gaming.

### Epic Games
Store giochi.

---

# 📚 Appendice

## Alias Consigliati

Aggiungi al tuo `~/.zshrc`:

```bash
# Navigazione moderna
alias ls='eza --icons'
alias ll='eza -lah --icons'
alias la='eza -la --icons'
alias lt='eza --tree --icons -L 2'
alias cat='bat'
alias grep='rg'
alias find='fd'
alias cd='z'

# Git shortcuts
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
alias gd='git diff'

# Directory
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Sicurezza
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# Utility
alias h='history | fzf'
alias ports='lsof -i -P -n | grep LISTEN'
alias ip='curl -s ipinfo.io | jq'
alias weather='curl wttr.in'
```

---

## Configurazione Git con Delta

Aggiungi a `~/.gitconfig`:

```ini
[core]
    pager = delta

[interactive]
    diffFilter = delta --color-only

[delta]
    navigate = true
    line-numbers = true
    side-by-side = false

[merge]
    conflictstyle = diff3

[diff]
    colorMoved = default
```

---

## Risorse Utili

- [[https://github.com/ibraheemdev/modern-unix|Modern Unix Tools]]
- [[https://www.wezm.net/technical/2019/10/useful-command-line-tools/|Useful CLI Tools]]
- [[https://jvns.ca/blog/2022/04/12/a-list-of-new-ish--command-line-tools/|New CLI Tools]]

---

*Guida generata per Setup Narsil ⚔️*
*Ultimo aggiornamento: Dicembre 2025*
