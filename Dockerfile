FROM ruby:2.2.5

RUN mkdir -p /code/public_attributes
WORKDIR /code/public_attributes
ADD . /code/public_attributes/

RUN bundle install

VOLUME /code/public_attributes
