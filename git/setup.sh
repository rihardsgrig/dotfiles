#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"

info "Configurating git..."

find . -name ".git*" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done

success "Finished configuring git."

# https://github.com/simonthum/git-sync
info "Installing git-sync..."

SCRIPT_LOC="$HOME/.dotfiles/bin"
SCRIPT_NAME="git-sync"
SCRIPT_PATH="${SCRIPT_LOC}/${SCRIPT_NAME}"
SCRIPT_URL="https://raw.githubusercontent.com/simonthum/git-sync/master/git-sync"


if [[ -a "$SCRIPT_PATH" ]]; then
  substep_info "You already have git-sync installed. Removing $SCRIPT_PATH older version."
  rm -rf $SCRIPT_PATH
fi

# download git-sync
substep_info "Fetching script..."
mkdir -p $SCRIPT_LOC
curl -sL $SCRIPT_URL > $SCRIPT_PATH && substep_info "Saved to ${SCRIPT_PATH}."
chmod +x $SCRIPT_PATH

# detect SCRIPT_LOC in path
IFS=":"
FOUND_PATH=""
for p in $PATH; do
  if [[ "$p" = "$SCRIPT_LOC" ]]; then
    FOUND_PATH="true"
    substep_info "Found ${SCRIPT_LOC} in \$PATH. All set!" >&2
  fi
done

substep_success "Successfully installed git-sync."

# tell user to adjust $PATH if necessary
if [[ -z "$FOUND_PATH" ]]; then
  substep_info "Now add ${SCRIPT_LOC} to \$PATH."
fi

success "git-sync is set up."
