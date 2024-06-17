# frozen_string_literal: true

require 'external_logger/base'
require 'forwardable'

class ExternalLogger::SendWarning < ExternalLogger::Base
  class << self
    extend Forwardable

    def_delegators :logger, :warn, :info, :debug

    def logger
      send("warning_sender_for_#{self::CURRENT_LOGGER}")
    end

    private

    def warning_sender_for_appsignal
      Appsignal::Logger.new('warning')
    end
  end
end
