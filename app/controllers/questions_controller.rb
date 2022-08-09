# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]
  before_action :check_author, only: %i[destroy edit update]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def edit; end

  def create
    @question = current_user.questions.create(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to @question, notice: 'Your question was successfully edited'
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Question was successfully deleted'
  end

  private

  def check_author
    return if current_user.creator_of?(@question)

    redirect_to question_path(@question),
                alert: 'Don`t touch - It`s not your'
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end
end
