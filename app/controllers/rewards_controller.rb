# frozen_string_literal: true

class RewardsController < ApplicationController
  before_action :authenticate_user!, only: %i[index]

  authorize_resource

  def index
    @rewards = current_user.rewards
  end
end
