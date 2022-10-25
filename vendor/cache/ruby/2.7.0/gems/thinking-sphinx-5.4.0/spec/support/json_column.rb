# frozen_string_literal: true

class JSONColumn
  include ActiveRecord::ConnectionAdapters

  def self.call
    new.call
  end

  def call
    ruby? && postgresql? && column?
  end

  private

  def column?
    (
      ActiveRecord::ConnectionAdapters.constants.include?(:PostgreSQLAdapter) &&
      PostgreSQLAdapter.constants.include?(:TableDefinition) &&
      PostgreSQLAdapter::TableDefinition.instance_methods.include?(:json)
    ) || (
      ActiveRecord::ConnectionAdapters.constants.include?(:PostgreSQL) &&
      PostgreSQL.constants.include?(:ColumnMethods) &&
      PostgreSQL::ColumnMethods.instance_methods.include?(:json)
    )
  end

  def postgresql?
    ENV['DATABASE'] == 'postgresql'
  end

  def ruby?
    RUBY_PLATFORM != 'java'
  end
end
