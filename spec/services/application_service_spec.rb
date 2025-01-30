# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationService do
  subject { described_class.call(*args) }

  let(:args) { [] }

  describe '.call' do
    context 'when a subclass implements #call' do
      let(:service_class) do
        Class.new(ApplicationService) do
          def initialize(value)
            @value = value
          end

          def call
            success_response(@value * 2)
          end
        end
      end

      let(:args) { [5] }
      subject { service_class.call(*args) }

      it 'calls the instance method and returns a successful response' do
        expect(subject).to be_success
        expect(subject.data).to eq(10)
        expect(subject.errors).to be_empty
      end
    end

    context 'when a subclass returns an error' do
      let(:service_class) do
        Class.new(ApplicationService) do
          def call
            error_response('Something went wrong')
          end
        end
      end

      subject { service_class.call }

      it 'returns an error response' do
        expect(subject).not_to be_success
        expect(subject.data).to be_nil
        expect(subject.errors).to eq(['Something went wrong'])
      end
    end
  end

  describe '#success_response' do
    let(:service_instance) { ApplicationService.new }

    it 'returns a successful OpenStruct object' do
      result = service_instance.send(:success_response, { message: 'Success' })

      expect(result).to be_success
      expect(result.data).to eq({ message: 'Success' })
      expect(result.errors).to eq([])
    end
  end

  describe '#error_response' do
    let(:service_instance) { ApplicationService.new }

    it 'returns an error OpenStruct object' do
      result = service_instance.send(:error_response, 'Invalid request')

      expect(result).not_to be_success
      expect(result.data).to be_nil
      expect(result.errors).to eq(['Invalid request'])
    end

    it 'handles multiple error messages' do
      result = service_instance.send(:error_response, ['Error 1', 'Error 2'])

      expect(result).not_to be_success
      expect(result.data).to be_nil
      expect(result.errors).to eq(['Error 1', 'Error 2'])
    end
  end
end
