FROM bibstha/ruby:2.1
MAINTAINER Bibek Shrestha, bibekshrestha@gmail.com

RUN apt-get update

# sshd, imagemagick
RUN apt-get install -y imagemagick libmagickwand-dev openssh-server

RUN mkdir /var/run/sshd 
RUN echo 'root:bharkhar_demo' |chpasswd
RUN \
  sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
  sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config && \
  sed -ri 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

ENV RACK_ENV production
ADD config        /app/config
ADD lib           /app/lib
ADD scripts       /app/scripts
ADD .ruby-version /app/
ADD Gemfile       /app/
ADD Gemfile.lock  /app/
ADD Rakefile      /app/

WORKDIR /app
VOLUME ["/data", "/log"]
EXPOSE 4567 22
CMD ["scripts/run.sh"]