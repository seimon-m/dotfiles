#! /usr/bin/env sh

DIR=$($(brew --prefix coreutils)/libexec/gnubin/dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$($(brew --prefix coreutils)/libexec/gnubin/realpath -m .)"
DESTINATION="$($(brew --prefix coreutils)/libexec/gnubin/realpath -m ~/Library/Application\ Support/Code/User)"

info "Setting up Visual Studio Code..."

substep_info "Installing Visual Studio Code extensions..."
cat extensions | while read extension; do
	$(brew --prefix)/bin/code --install-extension "$extension"
done

substep_info "Creating Visual Studio Code folders..."
mkdir -p "$DESTINATION"
mkdir -p "$DESTINATION/snippets"

substep_info "Symlinking Visual Studio Code settings..."
find * -not -name "$($(brew --prefix coreutils)/libexec/gnubin/basename ${0})" -type f | while read fn; do
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done

substep_info "Symlinking Visual Studio Code snippets..."
find snippets/* -type f | while read fn; do
	symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done

success "Finished setting up Visual Studio Code"
