# frozen_string_literal: true

class Question < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :user
  belongs_to :top_answer, required: false, class_name: 'Answer', dependent: :destroy, optional: true
  has_one :reward, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, :user, presence: true

  def sorted_answers
    return answers unless top_answer

    answers.sort_by { |a| a.top? ? 0 : 1 }
  end
end
