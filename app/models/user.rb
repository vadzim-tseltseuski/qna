# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy

  def creator_of?(resource)
    resource.user_id == id
  end

  def rewards
    Reward.where(answer_id: answers)
  end

  def able_to_vote?(votable)
    !creator_of?(votable) && votable.votes.pluck(:user_id).exclude?(id)
  end
end
