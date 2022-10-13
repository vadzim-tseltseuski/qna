# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action :load_link, only: %i[destroy]

  authorize_resource

  def destroy
    @link.destroy
  end

  private

  def load_link
    @link = Link.find(params[:id])
  end
end
