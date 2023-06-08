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

info "Installing PHP..."
versions=(php@7.4 php@8.0 php@8.1 php@8.1)
brew install ${versions[@]}
success "PHP install finished."

# https://gist.github.com/Synchro/58dc96a30527136478cde2dfcc13557b
info "Installing PHP switch script..."

SCRIPT_LOC="$HOME/.dotfiles/bin"
SCRIPT_NAME="sphp"
SCRIPT_PATH="${SCRIPT_LOC}/${SCRIPT_NAME}"
SCRIPT_URL="https://gist.githubusercontent.com/rihardsgrig/842cabe0b9109257f064845cc1687a97/raw/244027dbb4ab2661b6d13abce8f8e2dbf3759463/sphp"
#sphp 7.4 sphp 8.0 sphp 8.1


if [[ -a "$SCRIPT_PATH" ]]; then
  substep_info "You already have sphp installed. Removing $SCRIPT_PATH older version."
  rm -rf $SCRIPT_PATH
fi

# download sphp
substep_info "Fetching script..."
mkdir -p $SCRIPT_LOC
curl -sL $SCRIPT_URL > $SCRIPT_PATH && substep_info "Saved to ${SCRIPT_PATH}."
chmod +x $SCRIPT_PATH

success "sphp is set up."


