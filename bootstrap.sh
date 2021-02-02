#!/usr/bin/env bash

export RUBYVERSIONS

RUBYVERSIONS=(
 "2.4.4"
)

BREWSERVICES=(
 "mongodb-community@4.0"
 "redis"
)

title() {
  echo -e "\n\x1B[0;33m-- $1 --\x1B[0m"
}

error() {
  echo -e "\x1B[0;31m$1\x1B[0m"
}

success() {
  echo -e "\x1B[0;32m$1\x1B[0m"
}

echo "---------------------------------------"
echo "          BOOTSTRAP MACBOOK            "
echo "---------------------------------------"

dcross-bootsrap(){
  cd ~/Code/dcross/forklift

  if `gem list bson_ext -i --version 1.5.1`; then
    success "bson_ext v1.5.1 is installed!"
  else
    title "Installing BSON EXT"
    gem install bson_ext -v '1.5.1' -- --with-cflags="-Wno-error=implicit-function-declaration"
  fi

  if `gem list mysql2 -i --version 0.5.2`; then
    success "mysql2 v0.5.2 is installed!"
  else
    title "Installing mysql2 gem"
    export PKG_CONFIG_PATH="/usr/local/opt/mysql@5.7/lib/pkgconfig"
    export LDFLAGS="-L/usr/local/opt/mysql@5.7/lib"
    export CPPFLAGS="-I/usr/local/opt/mysql@5.7/include"

    export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/opt/openssl/lib/
    bundle config --local build.mysql2 "--with-ldflags=-L/usr/local/opt/openssl/lib --with-cppflags=-I/usr/local/opt/openssl/include"

    gem install mysql2 -v '0.5.2' -- --with-mysql-config=/usr/local/opt/mysql@5.7/bin/mysql_config
  fi

  if `gem list puma -i --version 4.3.5`; then
    success "puma v4.3.5 is installed!"
  else
    gem install puma:4.3.5 -- --with-cflags="-Wno-error=implicit-function-declaration"
  fi

  if `gem list rmagick -i --version 2.16.0`; then
    success "rmagick v2.16.0 is installed!"
  else
    PKG_CONFIG_PATH=/usr/local/opt/imagemagick@6/lib/pkgconfig gem install rmagick -v '2.16.0'
  fi

  bundle
}

rbenv init

for RUBYVERSION in "${RUBYVERSIONS[@]}"
do
  title "Installing Ruby Version $RUBYVERSION"

  rbenv install $RUBYVERSION -s
  rbenv global $RUBYVERSION

  if `gem list bundler -i --version 1.16.4`; then
    success "bundler v1.16.4 is installed!"
  else
    title "Installing Bundler"
    gem install bundler -v '1.16.4'
  fi
done


for BREWSERVICE in "${BREWSERVICES[@]}"
do
  title "Starting Service $BREWSERVICE"
  brew services start $BREWSERVICE
done

title "Setting dcross:forklift"
dcross-bootsrap

title "Setting up PUMA DEV"

sudo puma-dev -setup
puma-dev -install -d dev

cd ~/Code/dcross
puma-dev link -n dcross-forklift forklift
