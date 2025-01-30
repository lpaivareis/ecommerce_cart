# frozen_string_literal: true

require 'ostruct'

class ApplicationService
  def self.call(*, &)
    new(*, &).call
  end

  private

  def success_response(data = nil)
    OpenStruct.new(
      success?: true,
      data: data,
      errors: []
    )
  end

  def error_response(messages)
    OpenStruct.new(
      success?: false,
      data: nil,
      errors: Array(messages)
    )
  end
end
