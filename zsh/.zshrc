# Path to dotfiles.
export DOTFILES=~/.dotfiles

DEFAULT_USER="rihardsgrigorjevs"

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
autoload -U compinit && compinit

ZSH_CUSTOM=$DOTFILES/zsh_custom
ZSH_THEME="minimal/minimal"

COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="dd/mm/yyyy"
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=true
DISABLE_MAGIC_FUNCTIONS=true

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# Minimal - Theme Settings
export MNML_PROMPT=('mnml_cwd 3 0' mnml_status mnml_keymap)
export MNML_RPROMPT=(mnml_git)
export MNML_INFOLN=(mnml_err mnml_ssh)
export MNML_MAGICENTER=()

source $ZSH/oh-my-zsh.sh

source ~/.profile

# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish
