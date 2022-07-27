require 'rails_helper'

feature 'User can sign up', %q{
  To ask questions and give answers from a community
  As an unauthenticated user
  I'd like to be able to sign up
} do

  background do
    visit new_user_registration_path
    fill_in 'Email', with: 'email@qna.com'
  end

  scenario 'Unregistered user sign up' do
    fill_in 'Password', with: '123456789'
    fill_in 'Password confirmation', with: '123456789'
    within 'form' do
      click_on 'Sign up'
    end

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Registered user sign up' do
    user = create(:user)

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    within 'form' do
      click_on 'Sign up'
    end

    expect(page).to have_content "Email has already been taken"
  end

  scenario 'Unregistered user sign up with wrong password confirmation' do
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345'
    within 'form' do
      click_on 'Sign up'
    end

    expect(page).to have_content "Password confirmation doesn't match Password"
  end
end
