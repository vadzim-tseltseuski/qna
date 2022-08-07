require 'rails_helper'

feature 'User can delete question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to delete question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    given(:another_question) { create(:question) }

    background do
      sign_in(user)
    end

    scenario 'deletes his question' do
      visit question_path(question)
      click_on 'Delete question'



      expect(page).to_not have_content 'QuestionTitle'
      expect(page).to_not have_content 'QuestionBody'
    end

    scenario "deletes not his question" do
      visit question_path(another_question)

      expect(page).to have_no_link('Delete question')
    end
  end

  context 'Unauthenticated user' do
    scenario "deletes question" do
      visit question_path(question)

      expect(page).to have_no_link('Delete question')
    end
  end
end
