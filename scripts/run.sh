#! /bin/bash
cd /app
mkdir -p /data/bharkharapp/public
bundle exec rake download_latest
cp -r /app/lib/webapp/public /data/bharkharapp/public
/usr/local/bin/supervisord -c /app/config/supervisord.conf