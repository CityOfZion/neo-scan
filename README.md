# Neoscan 

[![Gitlab](https://gitlab.com/CityOfZion/neo-scan/badges/master/build.svg)](https://gitlab.com/CityOfZion/neo-scan/pipelines)
[![Coveralls](https://img.shields.io/coveralls/CityOfZion/neo-scan.svg?branch=master)](https://coveralls.io/github/CityOfZion/neo-scan)

Elixir + Phoenix Blockchain explorer for NEO.

# How to contribute

Using docker you can start the project with:
- `docker-compose up -d`
- `docker exec -it phoenixdev sh`
- `cd /data`

# Development
- Please run the tests after any changes 
- Please run the formatter after any changes `mix format` (you can use precommit hook: https://github.com/jasongoodwin/elixir-mix-format-pre-commit-hook)

To run, first install Elixir and Phoenix at:

* https://elixir-lang.org/install.html
* https://github.com/phoenixframework/phoenix

To run the tests:
 * Install dependencies with `mix deps.get --only test`
 * Create and migrate your database with `MIX_ENV=test mix ecto.create && mix ecto.migrate`
 * Run `mix test`

To start your The Application/Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd apps`, `cd neoscan_web`, then `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Make sure the username and password for your postgresSQL match the contents of "apps/neoscan/config/dev.exs"

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
