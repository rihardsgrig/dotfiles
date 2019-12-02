#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

sudo -v

# ###########################################################
# install homebrew (CLI Packages)
# ###########################################################
info "checking homebrew..."
brew_bin=$(which brew) 2>&1 > /dev/null
if [[ $? != 0 ]]; then
  substep_info "installing homebrew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  if [[ $? != 0 ]]; then
    error "unable to install homebrew, script $0 abort!"
    exit 2
  fi
else
  read -r -p "run brew update && upgrade? [y|N] " response
  if [[ $response =~ (y|yes|Y) ]]; then
    substep_info "updating homebrew..."
    brew update
    success "homebrew updated"
    substep_info "upgrading brew packages..."
    brew upgrade
    success "brews upgraded"
  else
    info "skipped brew package upgrades."
  fi
fi

# Just to avoid a potential bug
mkdir -p ~/Library/Caches/Homebrew/Formula
brew doctor

info "Installing Brewfile packages..."
brew bundle
success "Finished installing Brewfile packages."
