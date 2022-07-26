# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      @user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def admin_abilities
    can :manage, :all
  end

  def guest_abilities
    can :read, :all
    can :email, User
    can :set_email, User
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Subscription]
    can :comment, [Question, Answer]
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer, Subscription], user_id: user.id
    can :destroy, Reward, question: { user_id: user.id }
    can :destroy, Link, linkable: { user_id: user.id }
    can :index, Reward
    can :destroy, ActiveStorage::Attachment, record: { user_id: user.id }

    can :set_as_top, Answer, question: { user_id: user.id }
    can :answers, Question

    alias_action :vote_plus, :vote_minus, to: :vote
    can :vote, [Question, Answer] do |votable|
      !user.is_author?(votable)
    end

    can :delete_vote, [Question, Answer] do |votable|
      user.creator_of?(votable)
    end

    can %i[me others], User do |profile|
      profile.id == user.id
    end
  end
end
