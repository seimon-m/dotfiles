#!/usr/bin/env bash
# Modernized macOS defaults script for Apple Silicon / Ventura+
# Applies general UI/UX, Finder, Dock, Screenshots, and other safe settings.

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

info "Setting macOS defaults..."

# Close System Preferences to prevent overrides
osascript -e 'tell application "System Preferences" to quit'

# Ask for admin password upfront
sudo -v
# Keep-alive: update existing `sudo` timestamp
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX
###############################################################################

# Computer name
sudo scutil --set ComputerName "simon-mbp"
sudo scutil --set HostName "simon"
sudo scutil --set LocalHostName "simon"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "simon"

# Boot sound off
sudo nvram SystemAudioVolume=" "

# Sidebar icon size
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

# Always show scrollbars
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Expand save and print panels by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Auto-quit printer app
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

###############################################################################
# Trackpad, keyboard, input
###############################################################################

# Full keyboard access for all controls
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Disable press-and-hold for keys, fast repeat rate
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain KeyRepeat -int 3
defaults write NSGlobalDomain InitialKeyRepeat -int 12

# Disable auto-correct, smart quotes/dashes, auto-capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

###############################################################################
# Finder
###############################################################################

defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
sudo chflags nohidden /Volumes

###############################################################################
# Dock
###############################################################################

defaults write com.apple.dock tilesize -int 32
defaults write com.apple.dock mineffect -string "genie"
defaults write com.apple.dock minimize-to-application -bool false
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true
defaults write com.apple.dock show-process-indicators -bool true
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.15
defaults write com.apple.dock showhidden -bool true
defaults write com.apple.dock show-recents -bool false

###############################################################################
# Screenshots
###############################################################################

defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture location -string "${HOME}/Screenshots"
# defaults write com.apple.screencapture disable-shadow -bool false

###############################################################################
# Screen / security
###############################################################################

# Require password immediately after sleep/screensaver
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

###############################################################################
# Time Machine
###############################################################################

# Prevent Time Machine from prompting for new disks
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

###############################################################################
# App Store
###############################################################################

defaults write com.apple.appstore WebKitDeveloperExtras -bool true
defaults write com.apple.appstore ShowDebugMenu -bool true
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1
defaults write com.apple.commerce AutoUpdate -bool true
defaults write com.apple.commerce AutoUpdateRestartRequired -bool true


###############################################################################
# Kill affected apps
###############################################################################

for app in "Dock" "Finder" "SystemUIServer"; do
	killall "${app}" &> /dev/null
done

success "Finished applying macOS defaults. Logout/restart to apply all changes."
