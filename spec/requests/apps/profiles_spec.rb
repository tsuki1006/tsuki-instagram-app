require 'rails_helper'

RSpec.describe "Apps::Profiles", type: :request do

  let!(:user) { create(:user) }

  describe "GET /profile" do
    context 'ログインしている場合' do
      before do
        sign_in user
      end

      it "200 Status" do
        get profile_path
        expect(response).to have_http_status(200)
      end
    end

    context 'ログインしていない場合' do
      it 'ログイン画面に遷移する' do
        get profile_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PUT /profile' do
    context 'ログインしている場合' do
      before do
        sign_in user
      end

      it '200 Status' do
        avatar = fixture_file_upload('app/assets/images/test.png', 'image/png')
        profile_params = attributes_for(:profile).merge(avatar: avatar)

        put profile_path, params: { profile: profile_params }
        expect(response).to have_http_status(200)
        expect(user.profile.avatar.blob.filename).to eq('test.png')

        body = JSON.parse(response.body)
        expect(body['avatar_url']).to eq(Rails.application.routes.url_helpers.polymorphic_path(user.profile.avatar, only_path: true))
      end
    end

    context 'ログインしていない場合' do
      it '401 Status' do
        avatar = fixture_file_upload('app/assets/images/test.png', 'image/png')
        profile_params = attributes_for(:profile).merge(avatar: avatar)

        put profile_path(format: :json), params: { profile: profile_params }
        expect(response).to have_http_status(401)
      end
    end
  end
end
