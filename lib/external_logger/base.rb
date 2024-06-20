# frozen_string_literal: true

class ExternalLogger::Base
  CURRENT_LOGGER = :appsignal.freeze
  ADDITIONAL_LOGGERS = { rollbar: true }.freeze
end
