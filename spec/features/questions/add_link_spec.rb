require 'rails_helper'

feature 'User can add links for question', %q{
  In order to provide additional info to my question
  As an questions author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/vadzim-tseltseuski/b6d17f70e6ae691b907d0e76e5083297' }
  given(:url) { 'https://fbi.com' }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      within '#links' do
        click_on 'add'
      end
    end

    scenario 'can adds links', js: true do

      within(all('.nested-fields')[0]) do
        fill_in 'Link name', with: 'MyLink'
        fill_in 'Url', with: url
      end

      within '#links' do
        click_on 'add'
      end

      within(all('.nested-fields')[1]) do
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url
      end

      click_on 'Ask'

      within '.question' do
        expect(page).to have_link 'MyLink', href: url
        expect(page).to have_content 'Aut at quam laborum?'
      end
    end

    scenario 'tries add links with errors', js: true do
      within(all('.nested-fields')[0]) do
        fill_in 'Link name', with: ''
        fill_in 'Url', with: 'url'
      end

      click_on 'Ask'

      expect(page).to have_content 'Invalid format url'
      expect(page).to have_content "Links name can't be blank"
    end
  end
end
