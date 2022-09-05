# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_plus vote_minus delete_vote]
  end

  def vote_plus
    create_vote(1)
  end

  def vote_minus
    create_vote(-1)
  end

  def delete_vote
    respond_to do |format|
      @votable.votes.find_by(user: current_user)&.destroy
      format.json { render json: { rating: @votable.rating } }
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def create_vote(vote_value)
    @vote = @votable.votes.build(user: current_user, vote_value: vote_value)
    respond_to do |format|
      if @vote.save
        format.json { render json: { rating: @votable.rating } }
      else
        format.json do
          render json: { errors: @vote.errors.full_messages },
                 status: :unprocessable_entity
        end
      end
    end
  end
end
