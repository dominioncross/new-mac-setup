#!/usr/bin/env bash

title() {
  echo -e "\n\x1B[0;33m-- $1 --\x1B[0m"
}

echo "---------------------------------------"
echo "          PRE-BOOTSTRAP MACBOOK        "
echo "---------------------------------------"

title "Ensure bash is default"
chsh -s /bin/bash $(whoami)

title "Setup folder structure"
mkdir -p ~/.ssh ~/Code ~/bin ~/.puma-dev ~/.gcloud

title "Install homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
