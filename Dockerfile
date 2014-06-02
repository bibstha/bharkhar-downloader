FROM dockerfile/ubuntu

# ruby-install
RUN \
  wget -O ruby-install-0.4.3.tar.gz https://github.com/postmodern/ruby-install/archive/v0.4.3.tar.gz && \
  tar -xzvf ruby-install-0.4.3.tar.gz && \
  cd ruby-install-0.4.3/ && \
  make install && \
  ruby-install -i /usr/local ruby 2.1.2

RUN apt-get install -y imagemagick libmagickwand-dev

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

RUN gem install bundler

WORKDIR /app
ADD . /app

RUN bundle install --without development --without test