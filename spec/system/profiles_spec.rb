require 'rails_helper'

RSpec.describe "Profiles", type: :system do

  let!(:user) { create(:user) }
  let!(:article) { create(:article, :with_image, user: user) }
  let(:follower_user) { create(:user) }
  let(:following_user) { create(:user) }

  describe 'Profile' do
    describe 'ログイン前' do
      it 'ログインページに遷移' do
        visit profile_path
        expect(page).to have_current_path(new_user_session_path)
      end
    end

    describe 'ログイン後' do
      before do
        sign_in user
      end

      it 'プロフィール画面表示' do
        visit profile_path
        expect(page).to have_css('h2', text: user.name)
        expect(page).to have_content 'Posts'
        expect(page).to have_link 'Followers'
        expect(page).to have_link 'Followings'
        expect(page).to have_selector "img[src$='test.png']"
      end

      describe '画面遷移' do
        before do
          sign_in following_user
          sign_in follower_user
          user.follow!(following_user)
          follower_user.follow!(user)
          sign_in user
          visit profile_path
        end

        it 'followingsページ' do
          click_on 'Followings'
          expect(page).to have_current_path(account_followings_path(account_id: user.id))
          expect(page).to have_css('.account_name', text: following_user.name)
        end
        it 'followersページ' do
          click_on 'Followers'
          expect(page).to have_current_path(account_followers_path(account_id: user.id))
          expect(page).to have_css('.account_name', text: follower_user.name)
        end
      end

      describe 'アバター更新' do
        before do
          visit profile_path
        end
        it 'アバターが成功される', js: true do
          accept_alert('画像の更新に成功しました') do
            page.attach_file('app/assets/images/test-avatar.png') do
              page.find('.avatar').click
            end
          end
          expect(page).to have_selector "img[src$='test-avatar.png']"
        end
      end
    end
  end
end
