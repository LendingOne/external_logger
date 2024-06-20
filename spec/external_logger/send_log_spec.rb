# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ExternalLogger::SendLog do
  describe '#logger' do
    subject(:logger) { described_class.logger }

    it { expect(logger).to be_a(Appsignal::Logger) }
  end

  describe '#warn' do
    subject(:warn) { described_class.warn(message) }
    let(:message) { 'smth very wrong' }
    let(:appsignal_logger_instance) { Appsignal::Logger.new('warning') }

    it do
      expect(Appsignal::Logger).to receive(:new).with('warning').and_return(appsignal_logger_instance)
      expect(appsignal_logger_instance).to receive(:warn).with(message)
      expect(Rollbar).to receive(:warning).with(message)
      warn
    end
  end
end
