FROM bibstha/ruby:2.1
MAINTAINER Bibek Shrestha, bibekshrestha@gmail.com

RUN apt-get update

# sshd, imagemagick, python-pip for supervisord, redis-server
RUN apt-get install -y imagemagick libmagickwand-dev openssh-server python-pip redis-server

RUN mkdir /var/run/sshd 
RUN echo 'root:bharkhar_demo' |chpasswd
RUN \
  sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
  sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config && \
  sed -ri 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

RUN \
  sed -i 's/^\(bind .*\)$/# \1/' /etc/redis/redis.conf && \
  sed -i 's/^\(daemonize .*\)$/# \1/' /etc/redis/redis.conf && \
  sed -i 's/^\(dir .*\)$/# \1\ndir \/data/' /etc/redis/redis.conf && \
  sed -i 's/^\(logfile .*\)$/# \1/' /etc/redis/redis.conf

RUN pip install supervisor
RUN gem install bundler

ENV RACK_ENV production
ENV BHARKHAR_UPDATED 4

RUN git clone https://github.com/bibstha/bharkhar-downloader.git /app
WORKDIR /app
RUN bundle install --without development --without test
VOLUME ["/data", "/log"]
EXPOSE 4567 22
CMD ["scripts/run.sh"]