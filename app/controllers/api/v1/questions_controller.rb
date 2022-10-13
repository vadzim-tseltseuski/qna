# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      before_action :load_question, only: %i[show update destroy]

      skip_before_action :verify_authenticity_token
      authorize_resource

      def index
        @questions = Question.all
        render json: @questions, each_serializer: QuestionsSerializer
      end

      def show
        render json: @question
      end

      def create
        @question = current_resource_owner.questions.new(question_params)
        if @question.save
          render json: @question, status: :created
        else
          render json: { errors: @question.errors }, status: :bad_request
        end
      end

      def update
        if @question.update(question_params)
          head :ok
        else
          render json: { errors: @question.errors }, status: :bad_request
        end
      end

      def destroy
        @question.destroy
        head :no_content
      end

      def answers
        @answers = Question.find(params[:id]).answers
        render json: @answers, each_serializer: AnswersSerializer
      end

      private

      def load_question
        @question = Question.find(params[:id])
      end

      def question_params
        params.require(:question).permit(:title, :body)
      end
    end
  end
end
