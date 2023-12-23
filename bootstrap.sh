#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. scripts/functions.sh

info "Prompting for sudo password..."

if sudo -v; then
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
    success "Sudo credentials updated."
else
    error "Failed to obtain sudo credentials."
fi

info "Installing Rosetta..."
sudo softwareupdate --install-rosetta

./0-macos/setup.sh

find * -name "setup.sh" -not -wholename "0-macos*" -exec bash {} \;

info "Configure user bin folder..."

mkdir -p ~/bin
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc

success "Finished installing Dotfiles"
