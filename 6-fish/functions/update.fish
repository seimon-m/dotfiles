function update --description 'Get Safari Updates and update Homebrew, comoposer packages, and yarn packages'
    sudo softwareupdate -i --safari-only
    brew update
    brew upgrade
    brew autoremove
    sudo chown -R (whoami) (brew --prefix)/*
    brew cleanup
    yarn global upgrade
    composer global update
end
