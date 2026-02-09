require 'rails_helper'

RSpec.describe "Api::Follows", type: :request do

  let!(:users) { create_list(:user, 2) }
  let!(:user) { users.first }
  let!(:following) { users.second }

  describe "GET /api/accounts/:account_id/follow" do
    context 'ログインしている場合' do
      before do
        sign_in user
      end

      it "200 Status フォローの状態が返される" do
        get api_follow_path(account_id: following.id)
        expect(response).to have_http_status(200)

        body = JSON.parse(response.body)
        expect(body['isFollowing']).to eq(user.is_following?(following))
      end
    end

    context 'ログインしていない場合' do
      it '401 Status' do
        get api_follow_path(account_id: following.id, format: :json)
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'POST /api/accounts/:account_id/follow' do
    context 'ログインしている場合' do
      before do
        sign_in user
      end

      it '200 Status relationshipが作成される' do
        post api_follow_path(account_id: following.id)
        expect(response).to have_http_status(200)
        expect(Relationship.last.follower_id).to eq(user.id)
        expect(Relationship.last.following_id).to eq(following.id)

        body = JSON.parse(response.body)
        expect(body['status']).to eq('ok')
      end
    end

    context 'ログインしていない場合' do
      it '401 Status' do
        post api_follow_path(account_id: following.id, format: :json)
        expect(response).to have_http_status(401)
      end
    end
  end
end
