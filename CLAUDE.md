# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A Rails 6 API-only backend for **Rave Mom**, a Phaser 3 browser game. This repo just serves user accounts and high scores over JSON; the game itself lives in the separate frontend repo `rave-mom-app` (https://github.com/evantk91/rave-mom-app), which talks to this API via CORS.

Ruby 2.6.1, Rails ~6.0.2, PostgreSQL 12.

## Commands

```bash
bundle install                 # install gems
rails db:create db:migrate     # set up the database (dev)
RAILS_ENV=test rails db:create db:migrate   # set up the test database

rails s                        # run the API server

rails test                     # run the full test suite
rails test test/models/user_test.rb           # run a single test file
rails test test/models/user_test.rb:7         # run a single test by line number
```

Tests run in parallel by default (`parallelize(workers: :number_of_processors)` in `test/test_helper.rb`) and load all fixtures under `test/fixtures/*.yml` for every test.

There is no linter/rubocop configured in this repo.

## Architecture

Standard `config.api_only = true` Rails app — no views/helpers/assets, JSON responses only. All routes are namespaced under `api/v1` (see `config/routes.rb`), and controllers live under `app/controllers/api/v1/`.

**Auth model**: Homegrown JWT auth, not Devise/warden.
- `POST /api/v1/login` (`Api::V1::AuthenticationController#login`) checks username/password via `has_secure_password` on `User`, then signs a JWT with `Rails.application.secret_key_base` and payload `{ user_id: }`. On success it also returns the full score list alongside the token.
- `ApplicationController#authenticate` (`app/controllers/application_controller.rb`) is the shared before_action other controllers opt into. It reads `Authorization: Bearer <token>`, decodes the JWT with the same secret, and sets `@user`. There's no `ApplicationController#authenticate` failure short-circuit test coverage — treat auth changes here carefully since both the login controller and this method must stay in sync on secret/payload shape.
- `ScoresController` requires `authenticate` for `index`/`create`; `UsersController` does not currently require auth on any action (including `create`, i.e. signup).

**Domain model**: Just two models, `User` (`has_many :scores`, `has_secure_password`) and `Score` (`belongs_to :user`). No other resources.

**CORS**: Wide open (`origins '*'`) in `config/initializers/cors.rb` since this only serves a public game leaderboard/login — intentional, not an oversight.

When adding a new API endpoint, follow the existing pattern: add it under the `api/v1` namespace in `config/routes.rb`, create the controller in `app/controllers/api/v1/`, and add `before_action :authenticate` if it should be gated the same way `ScoresController` is.
