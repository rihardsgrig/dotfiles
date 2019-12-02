#! /usr/bin/env bash

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

info "Setting up zsh..."

# Ask for the administrator password upfront
sudo -v

# # Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

if [[ $SHELL =~ zsh ]]; then
  substep_success 'You already use zsh. Awesome!'
else
  substep_info 'Changing shell to zsh'
  # Adds zsh to shells
  command -v zsh | sudo tee -a /etc/shells
  chsh -s $(which zsh)
fi

success "Changed to ZSH"

# OH-MY-ZSH
if [ -d "$HOME/.oh-my-zsh" ]; then
  substep_info 'oh-my-zsh'
else
  substep_info 'Installing oh-my-zsh'
  curl -L http://install.ohmyz.sh | sh > /dev/null 2>&1
fi

success "Oh-my-zsh Installed"

success "FInished setting up ZSH"
