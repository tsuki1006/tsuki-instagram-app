require 'rails_helper'

RSpec.describe 'Api::Unfollows', type: :request do

  let!(:users) { create_list(:user, 2) }
  let!(:user) { users.first }
  let!(:following) { users.second }

  describe 'POST /api/accounts/:account_id/unfollow' do
    context 'ログインしている場合' do
      before do
        sign_in user
        user.follow!(following)
      end

      it '200 Status relationshipが削除される' do
        expect{ post api_unfollow_path(account_id: following.id)}.to change(Relationship, :count).by(-1)
        expect(response).to have_http_status(200)

        body = JSON.parse(response.body)
        expect(body['status']).to eq('ok')
      end
    end

    context 'ログインしていない場合' do
      it '401 Status' do
        post api_unfollow_path(account_id: following.id, format: :json)
        expect(response).to have_http_status(401)
      end
    end
  end
end
