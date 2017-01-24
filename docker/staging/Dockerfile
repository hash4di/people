FROM quay.io/netguru/ng-ruby:2.3.0

RUN /opt/passenger/install
RUN /opt/node/install

# bundle dependencies
RUN apt-get update && apt-get install -y libpq-dev imagemagick

# install nodejs 6.x
RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
RUN apt-get install -y nodejs

# set timezone
RUN echo "Europe/Warsaw" > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

ENV APP_HOME /var/www/app
ENV RAILS_ENV=staging

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install --jobs=8 --retry=3  --without development test --deployment

ADD . $APP_HOME/
ADD docker/staging/entrypoint.sh /entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/sbin/my_init"]
