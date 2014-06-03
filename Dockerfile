FROM bibstha/ruby:2.1
MAINTAINER bibekshrestha@gmail.com

# imagemagick
RUN apt-get update
RUN apt-get install -y imagemagick libmagickwand-dev

# supervisord
RUN apt-get install -y python-pip
RUN pip install supervisor

RUN \
  cd /tmp && \
  wget http://download.redis.io/redis-stable.tar.gz && \
  tar xvzf redis-stable.tar.gz && \
  cd redis-stable && \
  make && \
  make install && \
  cp -f src/redis-sentinel /usr/local/bin && \
  mkdir -p /etc/redis && \
  cp -f *.conf /etc/redis && \
  rm -rf /tmp/redis-stable* && \
  sed -i 's/^\(bind .*\)$/# \1/' /etc/redis/redis.conf && \
  sed -i 's/^\(daemonize .*\)$/# \1/' /etc/redis/redis.conf && \
  sed -i 's/^\(dir .*\)$/# \1\ndir \/data/' /etc/redis/redis.conf && \
  sed -i 's/^\(logfile .*\)$/# \1/' /etc/redis/redis.conf

ENV RACK_ENV production

RUN gem install bundler

RUN git clone https://github.com/bibstha/bharkhar-downloader.git /app
WORKDIR /app

RUN bundle install --without development --without test

VOLUME ["/data"]

EXPOSE 4567

CMD ["scripts/run.sh"]