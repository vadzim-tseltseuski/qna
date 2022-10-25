# frozen_string_literal: true

class ThinkingSphinx::Interfaces::Daemon < ThinkingSphinx::Interfaces::Base
  def start
    if command :running
      raise ThinkingSphinx::SphinxAlreadyRunning, 'searchd is already running'
    end

    command(options[:nodetach] ? :start_attached : :start_detached)
  end

  def status
    if command :running
      stream.puts "The Sphinx daemon searchd is currently running."
    else
      stream.puts "The Sphinx daemon searchd is not currently running."
    end
  end

  def stop
    command :stop
  end

  private

  delegate :controller, :to => :configuration
end
