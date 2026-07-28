FROM ruby:2.6.1

RUN apt-get update -qq && apt-get install -y --no-install-recommends libpq-dev \
    && rm -rf /var/lib/apt/lists/*

RUN gem install bundler -v 2.1.4

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3

COPY . .

ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true
ENV RAILS_SERVE_STATIC_FILES=false

EXPOSE 3000

CMD ["sh", "-c", "bundle exec rails db:migrate && bundle exec rails server -e production"]
