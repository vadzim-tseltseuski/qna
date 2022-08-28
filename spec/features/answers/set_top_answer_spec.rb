# frozen_string_literal: true

require 'rails_helper'

feature 'User can choose the top answer', "
  In order to check the most useful answer
  As an author of question
  I'd like to choose the top answer
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 4, question: question, user: user) }
  given!(:reward) { create(:reward, question: question) }
  given(:other_user) { create(:user) }
  given(:other_question) { create(:question, user: other_user) }
  given!(:other_answers) { create_list(:answer, 4, question: other_question, user: other_user) }

  scenario "Unauthenticated user can't choose answer as top" do
    visit question_path(question)
    expect(page).to have_no_link 'Mark as top'
  end

  describe 'Authenticated user' do
    background { sign_in(user) }

    scenario "can't choose answer as top for other user's question" do
      visit question_path(other_question)
      expect(page).to have_no_link 'Mark as top'
    end

    scenario 'choose answer as top for own question', js: true do
      visit question_path(question)

      best_answer = answers.drop(1).sample
      best_answer_xpath = ".//div[@data-answer-id='#{best_answer.id}']"

      within(:xpath, best_answer_xpath) { click_on 'Mark as top' }

      within :xpath, best_answer_xpath do
        expect(page).to have_no_link 'Mark as top'
      end

      expect(page).to have_selector ".top-answer"
      expect(page).to have_selector '.top-answer', count: 1

      question.reload
      expect(page.all(:css, '.answers .answer-text').map(&:text)).to eq question.sorted_answers.map(&:body)

      visit rewards_path

      expect(page).to have_css('img')
      expect(page).to have_text(reward.name)
    end
  end
end
