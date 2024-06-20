# frozen_string_literal: true

require 'external_logger/base'
require 'forwardable'

class ExternalLogger::SendLog < ExternalLogger::Base
  class << self
    extend Forwardable

    def_delegators :logger, :info, :debug, :error, :fatal

    def warn(message)
      self::ADDITIONAL_LOGGERS.each do |name, active|
        send("warning_sender_for_#{name}", message) if active
      end

      logger.warn(message)
    end

    def logger
      send("warning_sender_for_#{self::CURRENT_LOGGER}")
    end

    private

    def warning_sender_for_appsignal
      Appsignal::Logger.new('warning')
    end

    def warning_sender_for_rollbar(message)
      Rollbar.warning(message)
    end
  end
end
