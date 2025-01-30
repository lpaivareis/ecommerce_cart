# frozen_string_literal: true

require 'rails_helper'
RSpec.describe MarkCartAsAbandonedJob, type: :job do
  describe '#perform' do
    let(:carts) { double('carts') }

    before do
      allow(Cart).to receive(:where).and_return(carts)
      allow(Carts::AbandonedService).to receive(:call)
    end

    it 'calls Carts::AbandonedService' do
      described_class.new.perform

      expect(Carts::AbandonedService).to have_received(:call).with(carts)
    end
  end
end
