# frozen_string_literal: true

class ThinkingSphinx::ActiveRecord::Callbacks::AssociationDeltaCallbacks
  def initialize(path)
    @path = path
  end

  def after_commit(instance)
    Array(objects_for(instance)).each do |object|
      object.update :delta => true unless object.frozen?
    end
  end

  private

  attr_reader :path

  def objects_for(instance)
    path.inject(instance) { |object, method| object.send method }
  end
end
