require 'rails_helper'

feature 'User can delete answer', %q{
  In order to delete wrong answer
  As an authenticated user
  I'd like to be able to delete answer
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }


  given!(:question) { create(:question) }
  given!(:question2) { create(:question) }

  given!(:answer) { create(:answer, question: question, user: user) }

  given!(:another_question) { create(:question) }
  given!(:another_answer) { create(:answer, question: another_question) }

  given!(:answer_with_files) { create(:answer, :with_files, question: question2, user: user) }
  given!(:other_answer_with_files) { create(:answer, :with_files, question: question2, user: other_user) }

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)
    end

    scenario 'deletes his answer' do
      visit question_path(question)
      expect(page).to have_content 'Answer_Body'
      click_on 'Delete answer'

      expect(page).to_not have_content 'Answer_Body'
    end

    scenario "deletes not his answer" do
      visit question_path(another_question)

      expect(page).to have_no_link('Delete answer')
    end


    scenario 'deletes file of his answer', js: true do
      visit question_path(question2)

      answer_xpath = ".//div[@data-answer-id='#{answer_with_files.id}']"
      within(:xpath, answer_xpath) do
        within('.file') { click_on 'Delete file' }
        expect(page).to have_no_link answer_with_files.files.first.filename.to_s
      end
    end

    scenario 'tries to delete file of others answer' do
      visit question_path(question2)
      answer_xpath = ".//div[@data-answer-id='#{other_answer_with_files.id}']"
      within(:xpath, answer_xpath) do
        within('.file') do
          expect(page).to have_no_link 'Delete file'
        end
      end
    end
  end

  context 'Unauthenticated user' do
    scenario "edits answer" do
      visit question_path(question)

      expect(page).to have_no_link('Delete answer')
    end
  end
end