#!/usr/bin/env bash

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
echo "          INSTALL MYSQL2               "
echo "---------------------------------------"


if `gem list mysql2 -i --version 0.4.10`; then
  success "mysql2 v0.4.10 is installed!"
else
  title "Installing mysql2 gem"
  export PKG_CONFIG_PATH="/usr/local/opt/mysql@5.7/lib/pkgconfig"
  export LDFLAGS="-L/usr/local/opt/mysql@5.7/lib"
  export CPPFLAGS="-I/usr/local/opt/mysql@5.7/include"

  export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/opt/openssl/lib/
  bundle config --local build.mysql2 "--with-ldflags=-L/usr/local/opt/openssl/lib --with-cppflags=-I/usr/local/opt/openssl/include"

  gem install mysql2 -v '0.4.10' -- --with-mysql-config=/usr/local/opt/mysql@5.7/bin/mysql_config
fi
