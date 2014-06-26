#!/bin/bash
cd /app
/usr/sbin/sshd
bundle install --without development --without test
bundle exec sidekiq -r ./lib/bharkhar/workers/downloader.rb