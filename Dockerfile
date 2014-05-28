FROM dockerfile/ubuntu

# ruby-install
RUN \
  wget -O ruby-install-0.4.3.tar.gz https://github.com/postmodern/ruby-install/archive/v0.4.3.tar.gz && \
  tar -xzvf ruby-install-0.4.3.tar.gz && \
  cd ruby-install-0.4.3/ && \
  make install && \
  ruby-install -i /usr/local ruby 2.1.2

RUN apt-get install -y imagemagick libmagickwand-dev

WORKDIR /app
ADD . /app
RUN gem install bundler

RUN bundle