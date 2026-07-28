# ruby:2.6.1's only base is Debian stretch, whose libpq (9.6) is too
# old for Neon: it lacks SCRAM auth support (needs libpq >= 10).
# 2.6.10 is a same-line patch bump (bugfixes/security only) built on
# bullseye, which ships libpq 13.
FROM ruby:2.6.10-bullseye

RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends libpq-dev \
    && rm -rf /var/lib/apt/lists/*

RUN gem install bundler -v 2.1.4

WORKDIR /app

COPY Gemfile Gemfile.lock ./
# mimemagic's installer wants a system MIME database we don't need --
# this app never uses ActiveStorage's file-type detection.
ENV USE_FREEDESKTOP_PLACEHOLDER=true
RUN bundle install --jobs 4 --retry 3

COPY . .

ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true
ENV RAILS_SERVE_STATIC_FILES=false

EXPOSE 3000

CMD ["sh", "-c", "bundle exec rails db:migrate && bundle exec rails server -e production"]
