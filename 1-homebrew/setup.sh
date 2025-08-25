#!/usr/bin/env bash

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

sudo -v

info "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

info "Adding Brew to PATH..."
UNAME_MACHINE="$(/usr/bin/uname -m)"

if [[ "${UNAME_MACHINE}" == "arm64" ]]; then
    grep -qxF 'eval "$(/opt/homebrew/bin/brew shellenv)"' ~/.zshrc || \
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    grep -qxF 'eval "$(/usr/local/bin/brew shellenv)"' ~/.zshrc || \
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zshrc
    eval "$(/usr/local/bin/brew shellenv)"
fi

info "Installing Brew packages..."
brew update
brew upgrade
brew bundle --file=./Brewfile --no-lock
brew cleanup

# Optional PATH tweaks
grep -qxF 'eval "$(rbenv init - zsh)" >/dev/null 2>&1' ~/.zshrc || \
    echo 'eval "$(rbenv init - zsh)" >/dev/null 2>&1' >> ~/.zshrc
grep -qxF 'export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"' ~/.zshrc || \
    echo 'export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"' >> ~/.zshrc
grep -qxF 'export PATH="$(brew --prefix findutils)/libexec/gnubin:$PATH"' ~/.zshrc || \
    echo 'export PATH="$(brew --prefix findutils)/libexec/gnubin:$PATH"' >> ~/.zshrc
grep -qxF 'export PATH="$HOME/.composer/vendor/bin:$PATH"' ~/.zshrc || \
    echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.zshrc
grep -qxF 'fnm env --use-on-cd' ~/.zshrc || \
    echo 'fnm env --use-on-cd' >> ~/.zshrc

success "Finished installing Brew"
