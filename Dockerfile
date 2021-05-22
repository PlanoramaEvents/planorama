# Dockerfile

# Use ruby image to build our own image
FROM --platform=linux/x86_64 ruby:2.7.2-alpine as base

# Ensure that we work in UTF 8
ENV LANG C.UTF-8 # ensure that the encoding is UTF8
ENV LANGUAGE C.UTF-8 # ensure that the encoding is UTF8

# Specify an external volume for the Application source
VOLUME ["/opt/planorama"]

# And specify the work directory in which we will run the app server
WORKDIR /opt/planorama

# Use a persistent volume for the gems installed by the bundler
ENV BUNDLE_PATH /var/bundler

RUN apk add \
      build-base \
      freetds-dev \
      git \
      less \
      netcat-openbsd \
      nodejs \
      nodejs-npm \
      postgresql-client \
      postgresql-dev \
      pkgconfig \
      openssl \
      sqlite-dev \
      tzdata \
      yarn \
    && rm -rf /var/cache/apk/*

# Install bundler for this Docker image
RUN gem install bundler:2.2.4

COPY . /opt/planorama

# We install all the dependencies
RUN bundle install

# We expose the port
#EXPOSE 3000
# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
