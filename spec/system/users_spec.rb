require 'rails_helper'

RSpec.describe "Users", type: :system, display: true do

  let!(:user) { create(:user) }

  describe 'User' do

    describe 'Sign up' do
      before do
        visit new_user_registration_path
      end

      context 'フォームの入力値が正常' do
        it 'ユーザーの新規作成が成功' do
          fill_in 'Account', with: 'Account'
          fill_in 'Email', with: 'test@example.com'
          fill_in 'Password', with: 'Password'
          click_button 'CREATE ACCOUNT'
          expect(current_path).to eq root_path
          expect(page).to have_content 'Welcome! You have signed up successfully.'
        end
      end

      context 'name 未記入' do
        it 'ユーザーの新規作成が失敗' do
          fill_in 'Email', with: 'test@example.com'
          fill_in 'Password', with: 'Password'
          click_button 'CREATE ACCOUNT'
          expect(page).to have_content "Name can't be blank"
        end
      end
      context 'name 重複' do
        it 'ユーザーの新規作成が失敗' do
          fill_in 'Account', with: user.name
          fill_in 'Email', with: 'test@example.com'
          fill_in 'Password', with: 'Password'
          click_button 'CREATE ACCOUNT'
          expect(page).to have_content "Name has already been taken"

        end
      end
      context 'email 未記入' do
        it 'ユーザーの新規作成が失敗' do
          fill_in 'Account', with: 'Account'
          fill_in 'Password', with: 'Password'
          click_button 'CREATE ACCOUNT'
          expect(page).to have_content "Email can't be blank"
        end
      end
      context 'email 重複' do
        it 'ユーザーの新規作成が失敗' do
          fill_in 'Account', with: 'Account'
          fill_in 'Email', with: user.email
          fill_in 'Password', with: 'Password'
          click_button 'CREATE ACCOUNT'
          expect(page).to have_content "Email has already been taken"
        end
      end
      context 'password 未記入' do
        it 'ユーザーの新規作成が失敗' do
          fill_in 'Account', with: 'Account'
          fill_in 'Email', with: 'test@example.com'
          click_button 'CREATE ACCOUNT'
          expect(page).to have_content "Password can't be blank"
        end
      end
    end


    describe 'Sign in' do
      before do
        visit new_user_session_path
      end

      context 'フォームの入力値が正常' do
        it 'ログインが成功' do
          fill_in 'Email', with: user.email
          fill_in 'Password', with: user.password
          click_button 'LOGIN'
          expect(page).to have_current_path(root_path)
          expect(page).to have_content 'Signed in successfully.'
        end
      end

      context 'email 未記入' do
        it 'ログインが失敗' do
          fill_in 'Password', with: user.password
          click_button 'LOGIN'
          expect(page).to have_content 'Invalid Email or password.'
        end
      end
      context 'password 未記入' do
        it 'ログインが失敗' do
          fill_in 'Email', with: user.email
          click_button 'LOGIN'
          expect(page).to have_content 'Invalid Email or password.'
        end
      end
    end
  end
end
