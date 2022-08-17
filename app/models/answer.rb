# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_one :question_where_is_top,
          class_name: 'Question',
          foreign_key: :top_answer_id,
          inverse_of: 'top_answer',
          dependent: :nullify
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, :user, presence: true

  def set_as_top!
    question.update(top_answer: self)
    question.reward&.update(answer: self)
  end

  def top?
    question.top_answer_id == id
  end
end
