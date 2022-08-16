require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask question
} do

  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'create a question' do
      fill_in 'Title', with: 'Text title'
      fill_in 'Body', with: 'Text body'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created'
      expect(page).to have_content 'Text title'
      expect(page).to have_content 'Text body'
    end

    scenario 'asks a question with attached file' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text?'
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'create a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
