#!/bin/bash
set -e

bundle exec rake db:migrate
bundle exec rake assets:precompile
bundle exec rackup -p 5000 --host 0.0.0.0

