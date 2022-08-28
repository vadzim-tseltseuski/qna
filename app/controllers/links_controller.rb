# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action :load_link, only: %i[destroy]
  before_action :check_author, only: %i[destroy]

  def destroy
    @link.destroy
  end

  private

  def load_link
    @link = Link.find(params[:id])
  end

  def check_author
    return if current_user.creator_of?(@link.linkable)

    redirect_to question_path(@link.linkable),
                alert: 'Don`t touch - It`s not your'
  end
end
