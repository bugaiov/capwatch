# Capwatch

[![Build Status](https://travis-ci.org/bugaiov/capwatch.svg?branch=master)](https://travis-ci.org/bugaiov/capwatch)
[![Coverage Status](https://coveralls.io/repos/github/bugaiov/capwatch/badge.svg)](https://coveralls.io/github/bugaiov/capwatch)
[![Gem Version](https://badge.fury.io/rb/capwatch.svg)](https://badge.fury.io/rb/capwatch)

Watch your cryptoportfolio in a console

![Demo](http://i.imgur.com/wPZ9Rfe.png)

## Installation

    $ gem install capwatch
    $ capwatch

Don't forget to edit `~/.capwatch` with the amount of cryptocurrencies that you hold.

## Telegram

If you want to get portfolio notifications on demand into your telegram, you'll need:

1. Create a telegram bot via [BotFather](https://core.telegram.org/bots)
2. Get the bot `token`
3. Start capwatch with the bot `token` in hand

        $capwatch -e <bot_token>

Currently Capwatch supports only two commands

- `/watch` - shows the entire portfolio
- `/cap` - shows only the footer of the portfolio, e.g. summaries

Remember to start it on a server in a tmux window or as a daemon.

## Data Providers

- http://coinmarketcap.com

## Demo Funds

Fund examples can be found [here](spec/fixtures/funds) which were taken from [here](www.bluemagic.info)
