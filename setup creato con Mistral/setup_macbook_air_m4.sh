#!/bin/bash

# Script per installare Brew, zsh, font Meslo, Powerlevel10k e una serie di programmi selezionati
# su un nuovo MacBook Air con M4.

# 1. Installare Brew se non è già presente
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew is already installed."
fi

# 2. Installare zsh e configurarlo come shell predefinita
if ! command -v zsh &> /dev/null; then
    echo "Installing zsh..."
    brew install zsh
    chsh -s $(which zsh)
else
    echo "zsh is already installed."
fi

# 3. Scaricare e installare i font Meslo (necessari per Powerlevel10k)
echo "Installing Meslo fonts..."
brew tap homebrew/cask-fonts
brew install --cask font-meslo-lg-nerd-font

# 4. Installare Powerlevel10k
echo "Installing Powerlevel10k..."
brew install romkatv/powerlevel10k/powerlevel10k

# Aggiungere Powerlevel10k al file di configurazione di zsh
if [ ! -f ~/.zshrc ]; then
    touch ~/.zshrc
fi

if ! grep -q "powerlevel10k" ~/.zshrc; then
    echo "source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme" >> ~/.zshrc
fi

# 5. Installare le formule selezionate
echo "Installing formulas..."
formulas=(
    "git"
    "wget"
    "curl"
    "node"
    "python"
    "docker"
    "ffmpeg"
    "gh"
    "git-extras"
    "htop"
    "jq"
    "tmux"
    "tree"
    "zsh"
    "zsh-autosuggestions"
    "zsh-syntax-highlighting"
    "awscli"
    "bat"
    "broot"
    "cowsay"
    "fortune"
    "glow"
    "speedtest-cli"
)

brew install "${formulas[@]}"

# 6. Installare i cask selezionati
echo "Installing casks..."
casks=(
    "google-chrome"
    "visual-studio-code"
    "slack"
    "zoom"
    "docker-desktop"
    "iterm2"
    "obsidian"
    "font-meslo-lg-nerd-font"
    "anki"
    "calibre"
    "claude"
    "codex"
    "copilot"
    "mistral-vibe"
    "github"
    "vlc"
    "whatsapp"
)

brew install --cask "${casks[@]}"

echo "Installation completed!"
