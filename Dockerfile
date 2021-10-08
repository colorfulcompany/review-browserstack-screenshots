FROM ruby:3.0.0

ADD src /src
ADD Gemfile /Gemfile
ADD Gemfile /Gemfile.lock

RUN bundle install
RUN chmod +x /src/main.rb

ENTRYPOINT ["/src/main.rb"]
