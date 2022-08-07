require 'rails_helper'

feature 'User can see question and answers', %q{
  In order to get answer from a community
  As an (un)authenticated user
  I'd like to be able to see question and answers
} do
  given(:user) { create(:user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)

      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)
    end

    describe 'No answers' do
      given(:question) { create(:question) }

      scenario 'user sees question and message about no answers' do
        expect(page).to have_content "There are no any answers"
      end
    end

    describe 'With answers' do
      given(:question) { create(:question, :with_answers) }

      scenario 'user sees question and answers' do
        question.answers.map(&:body).each do |q|
          expect(page).to have_content(q, count: 1)
        end
      end
    end
  end

  describe 'Unuthenticated user', js: true do
    background do
      visit question_path(question)

      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)
    end

    describe 'No answers' do
      given(:question) { create(:question) }

      scenario 'user sees question and message about no answers' do
        expect(page).to have_content "There are no any answers"
      end
    end

    describe 'With answers' do
      given(:question) { create(:question, :with_answers) }

      scenario 'user sees question and answers' do
        question.answers.map(&:body).each do |q|
          expect(page).to have_content(q, count: 1)
        end
      end
    end
  end
end
