require 'rails_helper'

RSpec.describe "Accounts", type: :system do

  describe 'Account' do

    let!(:user) { create(:user) }
    let!(:target_user) { create(:user) }
    let(:follower) { create(:user) }
    let(:following) { create(:user) }

    it 'アカウント情報が表示される' do
      visit account_path(target_user)
      expect(page).to have_css('h2', text: target_user.name)
      expect(page).to have_content 'Posts'
      expect(page).to have_link 'Followers'
      expect(page).to have_link 'Followings'
    end

    describe 'ログイン不要' do
      describe '画面遷移' do
        before do
          sign_in following
          sign_in follower
          target_user.follow!(following)
          follower.follow!(target_user)
          visit account_path(target_user)
        end

        it 'followingsページ' do
          click_on 'Followings'
          expect(page).to have_current_path(account_followings_path(account_id: target_user.id))
          expect(page).to have_css('.account_name', text: following.name)
        end
        it 'followersページ' do
          click_on 'Followers'
          expect(page).to have_current_path(account_followers_path(account_id: target_user.id))
          expect(page).to have_css('.account_name', text: follower.name)
        end
      end
    end

    describe 'ログイン後' do
      before do
        sign_in user
        visit account_path(target_user)
      end
      it 'follow/unfollow ボタン表示' do
        expect(page).to have_content 'follow'
        find('.follow').click
        expect(page).to have_content 'unfollow'
      end
    end
  end
end
