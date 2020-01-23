#!/bin/bash
cd /home/bottlenose/bottlenose
export RAILS_ENV="production"
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
source "$HOME/.rvm/scripts/rvm"
#screen -d -m -S backburner bundle exec rake backburner:work
bundle exec rake backburner:work
