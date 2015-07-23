FROM ruby:2.2.0


MAINTAINER amir@barylko.com

# Install packages for building ruby
RUN apt-get update
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN apt-get install -y --force-yes nodejs libffi-dev libcurl4-gnutls-dev python2.7

RUN gem update --system
RUN gem install bundler

RUN ln -s /usr/bin/python2.7 /usr/local/bin/python

RUN git clone https://github.com/westerndevs/western-devs-website.git /root/jekyll
RUN cd /root/jekyll; bundle install

WORKDIR /root/jekyll

EXPOSE 4000
#CMD ["jekyll", "serve", "--host 0.0.0.0", "--config _config.yml,_config-dev.yml", "--force_polling"]
