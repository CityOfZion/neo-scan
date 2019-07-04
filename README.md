# Neoscan

# Contents
<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:0 orderedList:0 -->
- [How to contribute](#how-to-contribute)
- [Run Docker](#run-docker)
- [Run Tests](#run-tests)
- [Raise Main Net Phoenix](#raise-main-net-phoenix)
- [Raise Test Net Phoenix](#raise-test-net-phoenix)
- [PostgreSQL Fu](#postgresql-fu)
- [Learn More](#learn-more)

<!-- /TOC -->

[![Gitlab](https://gitlab.com/CityOfZion/neo-scan/badges/master/build.svg)](https://gitlab.com/CityOfZion/neo-scan/pipelines)
[![Coveralls](https://img.shields.io/coveralls/CityOfZion/neo-scan.svg?branch=master)](https://coveralls.io/github/CityOfZion/neo-scan)

Elixir + Phoenix Blockchain explorer for NEO

# How to Contribute

To run, first install Elixir and Phoenix at:

* https://elixir-lang.org/install.html
* https://github.com/phoenixframework/phoenix

# Development
- Please run the tests after any changes
- Please run the formatter after any changes `mix format` (you can use precommit hook: https://github.com/jasongoodwin/elixir-mix-format-pre-commit-hook)

## Run Docker

You can skip this section if you do not wish to with docker. 

Using docker you can start the project with:
- `docker-compose up -d`
- `docker exec -it phoenixdev sh`
- `cd /data`

### Run Tests

To run the tests:
 * Install dependencies with `mix deps.get --only test`
 * Create and migrate your database with `MIX_ENV=test mix ecto.create && mix ecto.migrate`
 * Run `mix test`

### Raise Main Net Phoenix

To start your The Application/Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd apps`, `cd neoscan_web`, then `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

### Raise Test Net Phoenix

To start your The Application/Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd apps`, `cd neoscan_web`, then `cd assets && npm install`
  * Start Phoenix endpoint with `NEO_SEEDS="https://seed1.neo.org:20331;http://seed2.neo.org:20332" mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Make sure the username and password for your PostgreSQL match the contents of "apps/neoscan/config/dev.exs"

## PostgreSQL Fu

Dump your database with pg_dump, i.e.,

To tarball:

`pg_dump -U postgres -h localhost -W -F t neoscan_dev > neoscan_dev_testnet.tar`

To file:

`pg_dump -U postgres -h localhost -W -F t neoscan_dev > neoscan_dev_testnet`

Restore:

`pg_restore --dbname=neoscan_dev --verbose neoscan_dev_testnet.tar`


## Notes

- Docker runs as root so if you go back and forth between source repository and docker style execution you will need to be mindful to chown any files that were created. These can easily be found when you see a permission denied error on some build step.

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
