require 'rails_helper'

RSpec.describe 'Accounts', type: :request do

  let!(:users) { create_list(:user, 2) }
  let!(:user) { users.first }
  let!(:user_other) { users.second }

  describe 'GET /accounts/:id' do
    it '200 Status' do
      get account_path(user_other)
      expect(response).to have_http_status(200)
    end

    context 'ログインして自分のページを表示する場合' do
      before do
        sign_in user
      end

      it 'Profile画面に遷移' do
        get account_path(user)
        binding.pry
        expect(response).to redirect_to(profile_path)
      end
    end
  end
end
