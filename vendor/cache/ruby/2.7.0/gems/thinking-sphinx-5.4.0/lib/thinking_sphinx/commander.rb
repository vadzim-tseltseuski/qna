# frozen_string_literal: true

class ThinkingSphinx::Commander
  def self.call(command, configuration, options, stream = STDOUT)
    raise ThinkingSphinx::UnknownCommand unless registry.keys.include?(command)

    registry[command].call configuration, options, stream
  end

  def self.registry
    @registry ||= {
      :clear_real_time  => ThinkingSphinx::Commands::ClearRealTime,
      :clear_sql        => ThinkingSphinx::Commands::ClearSQL,
      :configure        => ThinkingSphinx::Commands::Configure,
      :index_sql        => ThinkingSphinx::Commands::IndexSQL,
      :index_real_time  => ThinkingSphinx::Commands::IndexRealTime,
      :merge            => ThinkingSphinx::Commands::Merge,
      :merge_and_update => ThinkingSphinx::Commands::MergeAndUpdate,
      :prepare          => ThinkingSphinx::Commands::Prepare,
      :rotate           => ThinkingSphinx::Commands::Rotate,
      :running          => ThinkingSphinx::Commands::Running,
      :start_attached   => ThinkingSphinx::Commands::StartAttached,
      :start_detached   => ThinkingSphinx::Commands::StartDetached,
      :stop             => ThinkingSphinx::Commands::Stop
    }
  end
end
