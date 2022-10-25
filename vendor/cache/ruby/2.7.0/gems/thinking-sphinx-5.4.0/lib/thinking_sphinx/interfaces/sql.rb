# frozen_string_literal: true

class ThinkingSphinx::Interfaces::SQL < ThinkingSphinx::Interfaces::Base
  def initialize(configuration, options, stream = STDOUT)
    super

    configuration.preload_indices

    command :prepare
  end

  def clear
    command :clear_sql, :indices => (filtered? ? filtered_indices : indices)
  end

  def index(reconfigure = true, verbose = nil)
    stream.puts <<-TXT unless verbose.nil?
The verbose argument to the index method is now deprecated, and can instead be
managed by the :verbose option passed in when initialising RakeInterface. That
option is set automatically when invoked by rake, via rake's --silent and/or
--quiet arguments.
    TXT
    return if indices.empty?

    command :configure if reconfigure
    command :index_sql,
      :indices => (filtered? ? filtered_indices.collect(&:name) : nil)
  end

  def merge
    command :merge_and_update
  end

  private

  def filtered?
    index_names.any?
  end

  def filtered_indices
    indices.select { |index| index_names.include? index.name }
  end

  def index_names
    @index_names ||= options[:index_names] || []
  end

  def indices
    @indices ||= configuration.indices.select do |index|
      index.type == 'plain' || index.type.blank?
    end
  end
end
