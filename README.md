# Capwatch

[![Build Status](https://travis-ci.org/bugaiov/capwatch.svg?branch=master)](https://travis-ci.org/bugaiov/capwatch)
[![Coverage Status](https://coveralls.io/repos/github/bugaiov/capwatch/badge.svg)](https://coveralls.io/github/bugaiov/capwatch)
[![Gem Version](https://badge.fury.io/rb/capwatch.svg)](https://badge.fury.io/rb/capwatch)

Watch your cryptoportfolio in a console

![Demo](http://i.imgur.com/wPZ9Rfe.png)

## Installation

    $ gem install capwatch
    $ capwatch

Don't forget to edit `~/.capwatch` with a number of cryptocurrencies you hold.

## Remote Config

If you want to store the configuration of the fund remotely, please do so by creating a file `~/.capwatch.remote`.
It will automatically be read in priority to the local one. The file should just contain the URL which will yield fund.

Example

    $ cat ~/.capwatch.remote
    http://yourhost.com/fund.json

## Currency

You can select which currency to use but editing the `"currency": "USD"` line in the fund. (default: USD)

## CryptoList

    $ capwatch -a

Will show you the top 100 currencies sorted by market capitalization


## Watch

    $ capwatch -w

You can watch you portfolio in real time by added the `-w` option


## Anybar

    $ capwatch --anybar

Also please install [this fork](https://github.com/sfsam/AnyBar) of Anybar, works currently only on macOS

## Telegram

If you want to get portfolio notifications on demand into your telegram, you'll need:

1. Create a telegram bot via [BotFather](https://core.telegram.org/bots)
2. Get the bot `token`
3. Start capwatch with the bot `token` in hand

        $capwatch -e <bot_token>

Currently, Capwatch supports only two commands

- `/watch` - shows the entire portfolio
- `/cap` - shows only the footer of the portfolio, e.g. summaries

Remember to start it on a server in a tmux window or as a daemon.

## Available Data Providers

1. http://coinmarketcap.com

## Demo Funds

Fund examples can be found [here](spec/capwatch/fixtures/no_fiat_currency.json) which were taken from [here](http://www.bluemagic.info)
