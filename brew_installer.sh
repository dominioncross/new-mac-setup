#!/usr/bin/env bash

BREWS=(
 "coreutils"
 "gcc"
 "git"
 "github/gh/gh"
 "htop"
 "kubectl"
 "mongodb-community@4.0"
 "mongodb-database-tools"
 "mysql@5.7"
 "node"
 "nvm"
 "openssl"
 "pkg-config"
 "postgres"
 "puma/puma/puma-dev"
 "pyenv"
 "rbenv"
 "readline"
 "redis"
 "ruby-build"
 "terminal-notifier"
 "vim"
 "yarn"
 "wget"
)

BREW_CASKS=(
 "atom"
 "chromedriver"
 "docker"
 "figma"
 "firefox"
 "google-cloud-sdk"
 "google-chrome"
 "iterm2"
 "slack"
 "spotify"
)

BREW_TAPS=(
 "mongodb/brew"
 "homebrew/services"
)

error() {
  echo -e "\x1B[0;31m$1\x1B[0m"
}

error_exit() {
  echo "$1" 1>&2
  exit 1
}

format_title() {
  BLUE="\033[1;34m"
  NO_COLOUR="\033[0m"

  string=$1 && shift

  echo -e "$BLUE"
  echo "$string"
  echo -e "$NO_COLOUR"
}

title() {
  echo -e "\n\x1B[0;33m-- $1 --\x1B[0m"
}

if ! [ -x "$(command -v brew)" ]; then
  echo 'Error: brew is not installed.' >&2
  exit 1
fi

format_title "Installing Brews"
title "Brew Taps"

for brew_tap in "${BREW_TAPS[@]}"
do
  brew tap $brew_tap
done

title "Brews"

for brew in "${BREWS[@]}"
do
  brew install $brew
done

title "Brew imagemagick"
brew install imagemagick@6

title "Brew Casks"
for brew_cask in "${BREW_CASKS[@]}"
do
  brew install $brew_cask --cask
done
