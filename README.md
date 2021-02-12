# New-mac-setup

#### To setup the new Mac, please follow the the steps below.
-----------------

1. Clone the repo and Go the folder

2. Run `chmod +x pre-bootstrap.sh`

3. Run `./pre-bootstrap.sh`

The above steps will 
- "Ensure bash is default"
- "Setup folder structure"
- "Install homebrew"

This will be finished with 
```
==> Next steps:
- Run `brew help` to get started
- Further documentation: 
    https://docs.brew.sh
```

4. Run `chmod +x brew_installer.sh`

5. `./brew_installer.sh`

The above steps will install different packages, applications and services required. Once that is finished, the bash profile will require editing. To edit the bash profile

6. Run `vim ~/.bash_profile`

7. Press ‘i’ for inserting text

then paste
```
export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/Code/msi-utils/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/mongodb-community@4.0/bin:$PATH"
export CLOUDSDK_PYTHON=python3
export TERMINAL_NOTIFIER_BIN=/usr/local/bin/terminal-notifier

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc"
source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc"

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

export BASH_SILENCE_DEPRECATION_WARNING=1
```
8. press `esc` and then `:wq` to save and quit

9. Close and open a new terminal

10. Clone the dcross repo from github

11. Go to `~/Code/dcross`

12. Run `chmod +x bootstrap.sh`

13. Run `./bootstrap.sh`

The above steps will install all the require ruby gems 

14. Run `bundle exec rspec`

This will run the test and should show

```
macbook-pro:forklift dcross$ bundle exec rspec
/Users/dcross/.rbenv/versions/2.4.4/lib/ruby/gems/2.4.0/gems/fog-1.23.0/lib/fog/rackspace/mock_data.rb:42: warning: key "name" is duplicated and overwritten on line 80
DEPRECATION WARNING: The configuration option `config.serve_static_assets` has been renamed to `config.serve_static_files` to clarify its role (it merely enables serving everything in the `public` folder and is unrelated to the asset pipeline). The `serve_static_assets` alias will be removed in Rails 5.0. Please migrate your configuration files accordingly. (called from block in <top (required)> at /Users/dcross/Code/dcross/forklift/config/environments/test.rb:12)
loading IconicAPI

Randomized with seed 15786
/Users/dcross/.rbenv/versions/2.4.4/lib/ruby/gems/2.4.0/gems/fog-1.23.0/lib/fog/xenserver/utilities.rb:4: warning: constant ::Fixnum is deprecated
../Users/dcross/.rbenv/versions/2.4.4/lib/ruby/gems/2.4.0/gems/fog-1.23.0/lib/fog/xenserver/utilities.rb:4: warning: constant ::Fixnum is deprecated
/Users/dcross/.rbenv/versions/2.4.4/lib/ruby/gems/2.4.0/gems/fog-1.23.0/lib/fog/xenserver/utilities.rb:4: warning: constant ::Fixnum is deprecated
/Users/dcross/.rbenv/versions/2.4.4/lib/ruby/gems/2.4.0/gems/fog-1.23.0/lib/fog/xenserver/utilities.rb:4: warning: constant ::Fixnum is deprecated
/Users/dcross/.rbenv/versions/2.4.4/lib/ruby/gems/2.4.0/gems/fog-1.23.0/lib/fog/xenserver/utilities.rb:4: warning: constant ::Fixnum is deprecated
..

Finished in 2.06 seconds (files took 8.52 seconds to load)
4 examples, 0 failures

Randomized with seed 15786
```
If the test gets finished with 0 failures. Then all is good!
## The next step is to setup the database.
--------------------------------

15. Run `gcloud init`

16. authenticate, do not create a project, do not choose a region

17. Run `mkdir ~/tmp`

18. `cd ~/tmp`

19. run `sudo gsutil cp gs://dcross/_mongo/latest.tar latest.tar`

20. Run `tar -xzvf latest.tar`

21. Run `mv -f ~/tmp/home/bpetro_dominioncross_com_au/backup/dump ~/tmp/dump`

The repo `tmp` now should have all the dbs. They can be checked at
 `ls ~/tmp/dump` and will show databases dumps as,

 ```
affiliates	highstreet	tarmac
forklift	padlock		wholesale
```
## The next step is to restore databases locally.
-----------------

22. Run `mongorestore --drop dump/forklift --db forklift`

23. Run `mongorestore --drop dump/highstreet --db highstreet `

24. Run `mongorestore --drop dump/tarmac --db tarmac `

25. Run `mongorestore --drop dump/padlock --db padlock `

26. Run `mongorestore --drop dump/wholesale --db wholesale`

This will restore all the databases. To update the database locally, run steps 18-26 and remove the repo `dump`

## The next step is to setup a development server links via puma-dev 
----------------------------------------------------------------
This will run the app on the browser. For example, to setup the wholesale app,

27. `puma-dev --install -d test`

this will install `.test` TLD. The default TLD of puma-dev is `.dev`, which is a reserved TLD.

28. `cd ~/Code/dcross/wholesale`
29. `bundle install`
30. `cd ~/Code/dcross`
31. `puma-dev link -n dcross-wholesale wholesale`

The above steps will give the URL `https://dcross-wholesale.dev/`. This will run the app on the puma-dev server. Do this for each app to setup link.

## Install mysql for warehouse application
----------------------------------------------------------------

1. run `chmod +x mysql.sh`
2. run `./mysql.sh`

Start mysql service

3. `brew services start mysql@5.7`

this should show

```==> Successfully started `mysql@5.7` (label: homebrew.mxcl.mysql@5.7)```

in the warehouse repo run,

4. `bundle exec rails db:create`
5. `bundle exec rails db:migrate`

If it shows this: 

```Access denied for user 'warehouse_user'@'localhost' (using password: NO)Please provide the root password for your MySQL installation```

Create a user

6. `touch ~/Code/warehouse/.env`

7. `vim ~/Code/warehouse/.env`

Add the below to vim editors

8. `DB_USERNAME=root`

then in the warehouse repo run,

9. `bundle exec rails db:seed:development`

10. `bin/rails db:migrate RAILS_ENV=development`


