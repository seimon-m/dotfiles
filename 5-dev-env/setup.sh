#! /usr/bin/env sh

DIR=$($(brew --prefix coreutils)/libexec/gnubin/dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

sudo -v

SOURCE="$($(brew --prefix coreutils)/libexec/gnubin/realpath -m ~/.config/valet/Certificates)"
DESTINATION="$($(brew --prefix coreutils)/libexec/gnubin/realpath -m ~)"

info "Setting up Development Environment..."

substep_info "Setting up Valet..."
brew services start mariadb
brew services start mailhog

composer global require laravel/valet

$HOME/.composer/vendor/bin/valet install
symlink "$SOURCE" "$DESTINATION/.localhost-ssl"

SOURCE="$($(brew --prefix coreutils)/libexec/gnubin/realpath -m .)"
DESTINATION="$($(brew --prefix coreutils)/libexec/gnubin/realpath -m ~)"

mkdir -p ~/repos/valet
$HOME/.composer/vendor/bin/valet park ~/repos/valet

cd $(brew --prefix phpmyadmin)/share/phpmyadmin
$HOME/.composer/vendor/bin/valet link --secure phpmyadmin

sudo $HOME/.composer/vendor/bin/valet trust

substep_info "Setting up Ruby..."
eval "$(fnm env --use-on-cd)"
fnm install 18
fnm use 18
fnm default 18

substep_info "Setting up Ruby..."
eval "$(rbenv init - zsh)"
rbenv install 2.6.10
rbenv global 2.6.10

substep_info "Setting up Wordmove..."
gem install wordmove
gem install ed25519
gem install bcrypt_pbkdf

substep_info "Setting up Vim..."

find . -name ".vim*" | while read fn; do
    fn=$($(brew --prefix coreutils)/libexec/gnubin/basename $fn)
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done

git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

substep_info "Setting up .npmrc..."
symlink "$SOURCE/.npmrc" "$DESTINATION/.npmrc"

substep_info "Setting up Proxy Driver for Valet..."
symlink "$SOURCE/WordPressProxyValetDriver.php" "$DESTINATION/.config/valet/Drivers/WordPressProxyValetDriver.php"

substep_info "Setting up unlighthouse"
yarn global add @unlighthouse/cli puppeteer

substep_info "Configuring ssh..."
mkdir -p ~/.ssh
touch ~/.ssh/config

if [ ! -f ~/.ssh/id_ed25519 ]; then
	read -p "Enter your email address: " email
	ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/id_ed25519 -q -N ""
fi

success "Finished setting up Development Environment."
