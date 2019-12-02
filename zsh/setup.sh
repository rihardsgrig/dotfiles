#! /usr/bin/env sh

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
  substep_info 'Changing shell to zsh.'
  # Adds zsh to shells
  command -v zsh | sudo tee -a /etc/shells
  chsh -s $(which zsh)
fi

success "Changed to zsh."

# OH-MY-ZSH
if [ -d "$HOME/.oh-my-zsh" ]; then
  substep_info 'oh-my-zsh'
else
  substep_info 'Installing oh-my-zsh.'
  curl -L http://install.ohmyz.sh | sh > /dev/null 2>&1

  git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.dotfiles/zsh_custom/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.dotfiles/zsh_custom/plugins/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-completions $HOME/.dotfiles/zsh_custom/plugins/zsh-completions
  git clone https://github.com/subnixr/minimal $HOME/.dotfiles/zsh_custom/themes/minimal
fi

success "Oh-my-zsh Installed."

success "Finished setting up ZSH."


info "Creating symlinks for project dotfiles..."
now=$(date +"%Y.%m.%d.%H.%M.%S")

for file in .*; do
	if [[ $file == "." || $file == ".." ]]; then
	  continue
	fi
	substep_info "~/$file"
	# if the file exists, make backup:
	if [[ -e ~/$file ]]; then
	    mkdir -p ~/.dotfiles_backup/$now
	    mv ~/$file ~/.dotfiles_backup/$now/$file
	    substep_info "Backup saved as ~/.dotfiles_backup/$now/$file"
	fi
	# symlink might still exist
	unlink ~/$file > /dev/null 2>&1
	# create the link
	ln -s ~/.dotfiles/zsh/$file ~/$file
	substep_info "$file linked."
done

success "Symlinks created."
