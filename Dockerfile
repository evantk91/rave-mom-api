FROM ruby:2.6.1

# ruby:2.6.1 is based on Debian stretch, which is EOL and no longer
# served from the regular mirrors -- point apt at the archive instead.
RUN sed -i \
      -e 's|deb.debian.org|archive.debian.org|g' \
      -e 's|security.debian.org|archive.debian.org|g' \
      /etc/apt/sources.list \
    && apt-get update -qq -o Acquire::Check-Valid-Until=false \
    && apt-get install -y --no-install-recommends libpq-dev \
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
