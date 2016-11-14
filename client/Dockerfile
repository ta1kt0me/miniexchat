FROM elixir:latest

MAINTAINER Hiroki Tokutomi <p.wadachi@gmail.com>

COPY ticker /app
WORKDIR /app
# CMD iex --name node@client --cookie foo -r ticker.ex client.exs
CMD iex --name $(hostname)@bar.foo --cookie foo -r ticker.ex client.exs
