# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %i[create]
  before_action :set_answer, only: %i[update destroy set_as_top]
  before_action :check_author, only: %i[update destroy]

  def create
    @answer = current_user.answers.create(answer_params)
    @answer.assign_attributes(question: @question)
    @answer.save
  end

  def update
    @question = @answer.question
    @answer.update(answer_params)
  end

  def destroy
    @question = @answer.question
    @answer.destroy
  end

  def set_as_top
    return unless current_user.creator_of?(@answer.question)

    @answer.set_as_top!
  end

  private

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def check_author
    return if current_user.creator_of?(@answer)

    redirect_to question_path(@answer.question),
                alert: 'Don`t touch - It`s not your'
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body,
                                   files: [],
                                   links_attributes: %i[name url _destroy])
  end
end
