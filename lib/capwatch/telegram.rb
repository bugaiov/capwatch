# frozen_string_literal: true

require "erb"
require "logger"

module Capwatch

  class Telegram

    attr_reader :logger, :bot, :config

    def initialize(token)
      @config = config
      @logger = Logger.new(STDOUT, Logger::DEBUG)
      @logger.debug "Starting telegram bot..."
      @bot = TelegramBot.new(token: token)
      Console::Formatter.currency = config.currency
    end

    def new_fund
      config = Fund::Config.new
      provider = Providers::CoinMarketCap.new(config: config)
      Fund.new(provider: provider, config: config)
    end

    def template(name)
      File.open(File.expand_path("#{__dir__}/../templates/#{name}")).read
    end

    def reply_cap
      fund = new_fund
      ERB.new(template("cap.erb")).result(binding)
    end

    def reply_watch
      fund = new_fund
      body = format_body(fund.serialize)
      ERB.new(template("watch.erb")).result(binding)
    end

    def format_body(body)
      JSON.parse(body).sort_by! { |e| -e["value_btc"].to_f }.map do |coin|
        [
          coin["name"],
          Console::Formatter.format_fiat(coin["price_fiat"]),
          coin["quantity"],
          Console::Formatter.format_percent(coin["distribution"].to_f * 100),
          Console::Formatter.format_btc(coin["value_btc"]),
          Console::Formatter.format_eth(coin["value_eth"]),
          Console::Formatter.format_percent(coin["percent_change_24h"]),
          Console::Formatter.format_percent(coin["percent_change_7d"]),
          Console::Formatter.format_fiat(coin["value_fiat"])
        ]
      end
    end

    def start
      bot.get_updates(fail_silently: true) do |message|
        logger.info "@#{message.from.username}: #{message.text}"
        command = message.get_command_for(bot)

        message.reply do |reply|
          begin

            case command

            when /\/cap/i
              reply.text = reply_cap
            when /\/watch/i
              reply.text = reply_watch
            else
              reply.text = "#{message.from.first_name}, have no idea what _#{command}_ means."
            end

            logger.info "sending #{reply.text.inspect} to @#{message.from.username}"
            reply.parse_mode = "Markdown"
            reply.send_with(bot)

          rescue => e
            logger.error e
          end
        end
      end
    end

  end
end
