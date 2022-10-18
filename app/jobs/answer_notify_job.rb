# frozen_string_literal: true

class AnswerNotifyJob < ApplicationJob
  queue_as :default

  def perform(answer)
    AnswerNotify.new.send_notify(answer)
  end
end
