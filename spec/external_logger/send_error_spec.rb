# frozen_string_literal: true

require 'spec_helper'

RSpec.shared_examples 'result is correct' do |underwritten_ncf|
  it do
    expect(Appsignal).to receive(:set_error)
    expect(result).to be_a(error_class)
    expect(result.message).to eq(error_message)
  end
end

RSpec.describe ExternalLogger::SendError do
  let(:params) { {} }
  let(:block) { proc{} }

  describe '#call' do
    subject(:result) { described_class.call(error, params, &block) }

    context 'when current logger is appsignal' do
      it { expect(described_class::CURRENT_LOGGER).to eq(:appsignal) }

      describe '#send_error_to_appsignal' do
        context 'when error is Exception' do
          let(:error) { StandardError.new('epic') }
          let(:error_class) { error.class }
          let(:error_message) { error.message }

          include_examples 'result is correct'

          context 'when block is present' do
            let(:block) { proc{ transaction.set_tags(smth: :smth) } }

            include_examples 'result is correct'
          end
        end

        context 'when error is String' do
          let(:error) { 'epic error' }
          let(:error_class) { described_class::AppsignalErrorWrapper }
          let(:error_message) { {} }

          include_examples 'result is correct'
          it { expect(result.class.name).to eq(error) }

          context 'when params are present' do
            let(:params) { { once_again: :epic } }
            let(:error_message) { params }

            include_examples 'result is correct'
            it { expect(result.class.name).to eq(error) }
          end
        end

        context 'when error is Hash' do
          let(:error) { { it_is: :a_hash } }
          let(:error_class) { described_class::AppsignalErrorWrapper }
          let(:error_message) { error }

          it { expect(result.class.name).to eq('Unnamed Error') }
        end

        context 'when error type is not supported' do
          let(:error) { 1 }
          let(:error_class) { described_class::AppsignalErrorWrapper }
          let(:error_message) { error }

          it do
            expect(Appsignal).not_to receive(:set_error)
            expect { result }.to raise_error(described_class::UnknowErrorType)
          end
        end
      end
    end
  end
end
