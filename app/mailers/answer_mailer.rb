# frozen_string_literal: true

class AnswerMailer < ApplicationMailer
  def new_answer(answer, user)
    @answer = answer
    @question = answer.question
    mail(to: user.email, subject: "You have new answer on '#{@question}'")
  end
end
