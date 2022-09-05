require 'rails_helper'

feature 'User can add links for answer', %q{
  In order to provide additional info to my answer
  As an answer author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user)}
  given(:url) { 'https://fbi.com' }
  given(:gist_url) { 'https://gist.github.com/vadzim-tseltseuski/b6d17f70e6ae691b907d0e76e5083297' }


  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)

      fill_in 'Body', with: 'answer body'

      within '.new-answer #links' do
        click_on 'add'
      end
    end

    scenario 'can adds links' do
      within(all('.new-answer .nested-fields')[0]) do
        fill_in 'Link name', with: 'MyLink'
        fill_in 'Url', with: url
      end
      within '.new-answer #links' do
        click_on 'add'
      end

      within(all('.new-answer .nested-fields')[1]) do
        fill_in 'Link name', with: 'MyGist'
        fill_in 'Url', with: gist_url
      end

      click_on 'Send answer'
      visit current_path

      within ".answers" do
        expect(page).to have_link 'MyLink', href: url
        expect(page).to have_content 'Aut at quam laborum?'
      end
    end

    scenario 'tries add links with errors' do
      within(all('.new-answer .nested-fields')[0]) do
        fill_in 'Link name', with: ''
        fill_in 'Url', with: 'url'
      end

      click_on 'Send answer'

      expect(page).to have_content 'Invalid format url'
      expect(page).to have_content "Links name can't be blank"
    end
  end
end