#!/bin/bash
cd /app
/usr/sbin/sshd
bundle install --without development --without test
bundle exec sidekiq -r ./workers.rb