#!/bin/bash
cd /app
bundle install --without development --without test
bundle exec sidekiq -r ./workers.rb