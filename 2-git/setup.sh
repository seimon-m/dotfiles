#! /usr/bin/env sh

DIR=$($(brew --prefix coreutils)/libexec/gnubin/dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$($(brew --prefix coreutils)/libexec/gnubin/realpath -m .)"
DESTINATION="$($(brew --prefix coreutils)/libexec/gnubin/realpath -m ~)"

info "Configuring git files..."

find . -name ".git*" | while read fn; do
    fn=$($(brew --prefix coreutils)/libexec/gnubin/basename $fn)
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done

# Request input for gitconfig user.name and user.email
read -p "Enter your git user.name: " name
read -p "Enter your git user.email: " email

# add user.name and user.email to gitconfig
$(brew --prefix)/bin/git config --global user.name "$name"
$(brew --prefix)/bin/git config --global user.email "$email"

success "Finished configuring git files."
