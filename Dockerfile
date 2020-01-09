FROM ruby:1.9

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

CMD ["bundle exec unicorn -p 8000 -c ./config/unicorn.rb"]
