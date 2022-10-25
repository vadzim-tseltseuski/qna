# frozen_string_literal: true

class ThinkingSphinx::ActiveRecord::LogSubscriber < ActiveSupport::LogSubscriber
  def guard(event)
    identifier = color 'Sphinx', GREEN, true
    warn "  #{identifier}  #{event.payload[:guard]}"
  end

  def message(event)
    identifier = color 'Sphinx', GREEN, true
    debug "  #{identifier}  #{event.payload[:message]}"
  end

  def query(event)
    identifier = color('Sphinx Query (%.1fms)' % event.duration, GREEN, true)
    debug "  #{identifier}  #{event.payload[:query]}"
  end

  def caution(event)
    identifier = color 'Sphinx', GREEN, true
    warn "  #{identifier}  #{event.payload[:caution]}"
  end
end

ThinkingSphinx::ActiveRecord::LogSubscriber.attach_to :thinking_sphinx
