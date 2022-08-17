require 'rails_helper'

feature 'User can delete link from question', %q{
  In order to delete wrong link from question
  As an authenticated user
  I'd like to be able to delete link
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:link) { create(:link, linkable: question) }
  given(:question2) { create(:question)}
  given(:another_link) {create(:link, linkable: question2) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
    end

    scenario 'delete link from own question' do
      visit question_path(question)
      click_on 'Delete link'

      expect(page).to_not have_link link.name
    end

    scenario "delete link from not own question" do
      visit question_path(question2)

      expect(page).to_not have_link('Delete link')
    end
  end

  context 'Unauthenticated user' do
    scenario "delete link" do
      visit question_path(question)

      expect(page).to_not have_link('Delete link')
    end
  end
end
