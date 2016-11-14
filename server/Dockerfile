FROM elixir:latest

MAINTAINER Hiroki Tokutomi <p.wadachi@gmail.com>

COPY ticker /app
WORKDIR /app
CMD iex --name server@baz.foo --cookie foo -r ticker.ex server.exs
