# frozen_string_literal: true

require 'external_logger/base'

class ExternalLogger::SendError < ExternalLogger::Base
  class UnknowErrorType < StandardError
    attr_reader :message

    def initialize(*attributes)
      @message = attributes
    end
  end

  class AppsignalErrorWrapper < StandardError
    attr_accessor :name, :message, :backtrace

    def initialize(name, params, backtrace = nil)
      @name = name
      @message = params
      @backtrace = backtrace
    end

    # we need to give back self so Appsignal gem gets correct name
    def class
      self
    end
  end

  class << self
    def call(error, params = {}, &block)
      self::ADDITIONAL_LOGGERS.each do |name, active|
        send("send_error_to_#{name.to_s}", error, params) if active
      end

      send("send_error_to_#{self::CURRENT_LOGGER}", error, params, &block)
    end

    private

    def send_error_to_rollbar(error, params)
      Rollbar.error(error, params)
    end

    def send_error_to_appsignal(error, params = {}, &block)
      case error
      when Exception
      when String
        error = AppsignalErrorWrapper.new(error, params)
        block = set_tags(params)
      when Hash
        error = AppsignalErrorWrapper.new('Unnamed Error', error, caller(1))
        block = set_tags(error: error)
      else
        raise UnknowErrorType, "error given #{error} with params #{params}"
      end

      Appsignal.set_error(error, &block)

      error
    end

    def set_tags(hash)
      proc { |transaction| transaction.set_tags(hash) }
    end
  end
end
