#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

sudo -v

# ###########################################################
# install homebrew (CLI Packages)
# ###########################################################
info "Checking homebrew..."
brew_bin=$(which brew) 2>&1 > /dev/null
if [[ $? != 0 ]]; then
  substep_info "Installing homebrew."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  if [[ $? != 0 ]]; then
    error "Unable to install homebrew, script $0 abort!"
    exit 2
  fi
else
  substep_info "Homebrew allready installed."
  read -r -p "Run brew update && upgrade? [y|N] " response
  if [[ $response =~ (y|yes|Y) ]]; then
    substep_info "Updating homebrew..."
    brew update
    success "Homebrew updated."
    substep_info "Upgrading brew packages..."
    brew upgrade
    success "Brews upgraded"
  else
    info "Skipped brew package upgrades."
  fi
fi

# Just to avoid a potential bug
mkdir -p ~/Library/Caches/Homebrew/Formula
brew doctor

info "Installing Brewfile packages..."
brew bundle
success "Finished installing Brewfile packages."

info "Cleaning up homebrew..."
brew cleanup --force > /dev/null 2>&1
rm -f -r /Library/Caches/Homebrew/* > /dev/null 2>&1
success "Clean up finished."
