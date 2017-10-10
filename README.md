# Neoscan Umbrella Application

[![Travis](https://img.shields.io/travis/CityOfZion/neo-scan.svg?branch=master&style=flat-square)](https://travis-ci.org/CityOfZion/neo-scan)

Elixir + Phoenix Blockchain explorer for NEO.
# How to contribute

Using docker you can start the project with:
- `docker-compose up -d`
- `docker exec -it neoscan_phoenix_1 sh`
- `cd /data`

# Prerequisites

You should have the following:

* Ruby - installing via [`rvm`](https://rvm.io/) (or [`rbenv`](https://github.com/rbenv/rbenv)) is the way to go here
* Node.js - as with Ruby we suggest using a Node.js version manager (ex: `nvm`)
* [Elixir](https://elixir-lang.org/install.html)
* [Phoenix](https://github.com/phoenixframework/phoenix)
* [Foreman](https://ddollar.github.io/foreman/)
    * `$ gem install foreman`


# Development

To start your Phoenix server:

```sh
# Copy and then fill your DB ENV variables (`DATABASE_USERNAME` & `DATABASE_PASSWORD` required)
$ cp .env.example .env

# Install dependencies with
$ mix deps.get

# Create and migrate your database with
$ mix ecto.create && mix ecto.migrate

# Install Node.js dependencies
$ cd apps/neoscan_web/assets && npm install

# Start Phoenix endpoint with
$ mix phx.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

**Note:** Please run `mix credo` after any changes and apply the suggestions before submitting PR's.

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
