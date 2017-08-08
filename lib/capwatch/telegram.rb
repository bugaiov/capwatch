require 'logger'

module Capwatch
  class Telegram

    attr_reader :logger, :bot, :fund

    def initialize(fund: FundParser.new.fund, token:)
      @fund = fund
      @logger = Logger.new(STDOUT, Logger::DEBUG)
      @logger.debug 'Starting telegram bot...'
      @bot = TelegramBot.new(token: token)
    end

    def start
      bot.get_updates(fail_silently: true) do |message|
        logger.info "@#{message.from.username}: #{message.text}"
        command = message.get_command_for(bot)

        message.reply do |reply|
          begin
            case command
            when /\/cap/i
              table = Console.format_table(Calculator.fund_hash(fund, CoinMarketCap.fetch))
              reply.text = table[:footer].reject(&:empty?).join("\n")
            when /\/watch/i
              table = Console.format_table(Calculator.fund_hash(fund, CoinMarketCap.fetch))
              text = [
                "*#{table[:title]}*",
                "\n",
                table[:table].map{|x| x.join("   |   ") }.join("\n"),
                "\n",
                table[:footer].reject(&:empty?).join("   |   ")
              ].join("\n")
              reply.text = text
            else
              reply.text = "#{message.from.first_name}, have no idea what _#{command}_ means."
            end
            logger.info "sending #{reply.text.inspect} to @#{message.from.username}"
            reply.parse_mode = 'Markdown'
            reply.send_with(bot)
          rescue => e
            logger.error e
          end
        end
      end
    end

  end
end
