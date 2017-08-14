# Capwatch

[![Build Status](https://travis-ci.org/bugaiov/capwatch.svg?branch=master)](https://travis-ci.org/bugaiov/capwatch)
[![Coverage Status](https://coveralls.io/repos/github/bugaiov/capwatch/badge.svg?branch=master)](https://coveralls.io/github/bugaiov/capwatch?branch=master)
[![Gem Version](https://badge.fury.io/rb/capwatch.svg)](https://badge.fury.io/rb/capwatch)

Watch your cryptoportfolio in a console

![Demo](http://i.imgur.com/ZkrFDtL.png)

## Installation

    $ gem install capwatch
    $ capwatch

Don't forget to edit `~/.capwatch` with the amount of cryptocurrencies that you hold. Also please change the name of the fund. 🤔

## Telegram

If you want to get portfolio notifications on demand to your telegram, you'll need:

1. Create a telegram bot via [BotFather](https://core.telegram.org/bots)
2. Get the bot `token`
3. Start capwatch with the bot `token` in hand


        $capwatch -e <bot_token>

Currently Capwatch supports only two commands

- `/watch` - shows the entire portfolio
- `/cap` - shows only the footer of the portfolio, e.g. summaries

Remember to start it on a server in a tmux window or as a daemon.

## Fund Examples

Fund examples can be found [here](spec/fixtures/funds)

Demo funds taken from www.bluemagic.info

Data is being processed from from http://coinmarketcap.com

