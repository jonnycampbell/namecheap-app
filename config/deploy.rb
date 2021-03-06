lock '3.3.5'

EXTRA_LINKED_DIRS  = %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
EXTRA_LINKED_FILES = %w{config/secrets.yml config/database.yml}

set :application, 'namecheap-app'
set :repo_url, 'git@github.com:pbalaban/namecheap-app.git'

ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

set :linked_files, fetch(:linked_files, []).push(*EXTRA_LINKED_FILES)
set :linked_dirs, fetch(:linked_dirs, []).push(*EXTRA_LINKED_DIRS)

after 'deploy:publishing', 'unicorn:legacy_restart'
after 'deploy:finished', 'unicorn:restart'
