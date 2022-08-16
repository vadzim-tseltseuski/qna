require 'rails_helper'

feature 'User can delete question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to delete question
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:question_with_files) { create(:question, :with_files, user: user) }
  given(:other_question_with_files) { create(:question, :with_files, user: other_user) }

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

    scenario 'deletes file of his question', js: true do
      visit question_path(question_with_files)

      within '.question-files' do
        click_on 'Delete file'
        expect(page).to have_no_link question_with_files.files.first.filename.to_s
      end
    end

    scenario 'tries to delete file of others question' do
      visit question_path(other_question_with_files)

      within '.question-files' do
        expect(page).to have_no_link 'Delete file'
      end
    end
  end

  context 'Unauthenticated user' do
    scenario "deletes question" do
      visit question_path(question)

      expect(page).to have_no_link('Delete question')
    end
  end
end
