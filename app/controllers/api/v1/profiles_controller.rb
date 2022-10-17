# frozen_string_literal: true

module Api
  module V1
    class ProfilesController < Api::V1::BaseController
      def me
        authorize! :me, current_resource_owner
        render json: current_resource_owner
      end

      def others
        authorize! :others, current_resource_owner
        @users = User.where.not(id: current_resource_owner)
        render json: @users
      end
    end
  end
end
