# frozen_string_literal: true

require 'gon'

class ApplicationController < ActionController::Base
  before_action :gon_user, unless: :devise_controller?

  private

  def gon_user
    gon.user_id = current_user&.id || 0
  end
end
