# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :vote_value, presence: true,
                         numericality: { equal: -> { -1 || 1 },
                                         only_integer: true }

  validates :user_id, uniqueness: { scope: %i[votable_id votable_type] }

  validate :votable_author

  def votable_author
    errors.add(:user, 'can not be an author of votable resource!') if votable && user&.creator_of?(votable)
  end
end
