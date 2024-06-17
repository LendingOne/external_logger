# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ExternalLogger::SendWarning do
  describe '#logger' do
    subject(:logger) { described_class.logger }

    it { expect(logger).to be_a(Appsignal::Logger) }
  end
end
