FROM bibstha/ruby:2.1
MAINTAINER Bibek Shrestha, bibekshrestha@gmail.com

RUN apt-get update

# sshd, imagemagick, python-pip for supervisord, redis-server
RUN apt-get install -y imagemagick libmagickwand-dev openssh-server python-pip redis-server

RUN mkdir /var/run/sshd 
RUN echo 'root:bharkhar_demo' |chpasswd
RUN pip install supervisor
RUN gem install bundler

ENV RACK_ENV production
ENV BHARKHAR_UPDATED 1

RUN git clone https://github.com/bibstha/bharkhar-downloader.git /app
WORKDIR /app
RUN bundle install --without development --without test
VOLUME ["/data"]
EXPOSE 4567 22
CMD ["scripts/run.sh"]