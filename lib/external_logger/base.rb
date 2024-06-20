# frozen_string_literal: true

class ExternalLogger::Base
  CURRENT_LOGGER = :appsignal
  ADDITIONAL_LOGGERS = { rollbar: true }.freeze
end
