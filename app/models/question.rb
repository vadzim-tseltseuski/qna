# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  belongs_to :top_answer, required: false, class_name: 'Answer', dependent: :destroy, optional: true

  has_many_attached :files

  validates :title, :body, :user, presence: true

  def sorted_answers
    return answers unless top_answer

    answers.sort_by { |a| a.top? ? 0 : 1 }
  end
end
