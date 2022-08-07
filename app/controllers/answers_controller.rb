# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %i[new create]
  before_action :set_answer, only: %i[destroy]
  before_action :check_author, only: %i[destroy]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = current_user.answers.create(answer_params)
    @answer.assign_attributes(question: @question)

    if @answer.save
      redirect_to @question
    else
      render 'questions/show'
    end
  end

  def destroy
    @answer.destroy
    redirect_to question_path(@answer.question), notice: 'Answer was successfully deleted'
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def check_author
    unless current_user.creator_of?(@answer)
      redirect_to question_path(@answer.question),
                  alert: 'Don`t touch - It`s not your'
    end
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
