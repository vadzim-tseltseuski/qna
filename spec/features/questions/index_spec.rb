require 'rails_helper'

feature 'User can see list ofquestions', %q{
  In order to get answer from a community
  As an authenticated user or as a quest
  I'd like to be able to see list of questions
} do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background { sign_in(user) }

    describe 'if questions exist' do
      given!(:questions) { create_list(:question, 3) }

      scenario 'sees questions ' do
        visit questions_path
        expect(page).to have_content(questions.first.title, count: 3)
      end
    end

    describe 'if questions exist' do
      scenario 'sees message if no questions' do
        visit questions_path
        expect(page).to have_content "There are no any questions"
      end
    end
  end

  describe 'Unauthenticated user' do
    describe 'if questions exist' do
      given!(:questions) { create_list(:question, 3) }

      scenario 'sees questions ' do
        visit questions_path
        expect(page).to have_content(questions.first.title, count: 3)
      end
    end

    describe 'if questions exist' do
      scenario 'sees message if no questions' do
        visit questions_path
        expect(page).to have_content "There are no any questions"
      end
    end
  end
end
