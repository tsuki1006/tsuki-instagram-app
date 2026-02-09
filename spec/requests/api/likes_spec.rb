require 'rails_helper'

RSpec.describe "Api::Likes", type: :request do

  let!(:user) { create(:user) }
  let!(:article) { create(:article, :with_image, user: user) }

  describe "GET api/articles/:article_id/like" do
    context 'ログインしている場合' do
      before do
        sign_in user
      end

      it "200 Status" do
        get api_like_path(article_id: article.id)
        expect(response).to have_http_status(200)

        body = JSON.parse(response.body)
        expect(body['hasLiked']).to eq(user.has_liked?(article))
      end
    end

    context 'ログインしていない場合' do
      it '401 Status' do
        get profile_path(format: :json)
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'POST api/articles/:article_id/like' do
    context 'ログインしている場合' do
      before do
        sign_in user
      end

      it '200 Status likeが作成される' do
        post api_like_path(article_id: article.id)
        expect(response).to have_http_status(200)
        expect(Like.last.article_id).to eq(article.id)
        expect(Like.last.user_id).to eq(user.id)

        body = JSON.parse(response.body)
        expect(body['status']).to eq('ok')
      end
    end

    context 'ログインしていない場合' do
      it '401 Status' do
        post article_comments_path(article_id: article.id, format: :json)
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'DELETE api/articles/:article_id/like' do
    context 'ログインしている場合' do
      before do
        sign_in user
        post api_like_path(article_id: article.id)
      end

      it '200 Status likeが削除される' do
        expect{ delete api_like_path(article_id: article.id) }.to change(Like, :count).by(-1)
        expect(response).to have_http_status(200)

        body = JSON.parse(response.body)
        expect(body['status']).to eq('ok')
      end
    end

    context 'ログインしていない場合' do
      it '401 Status' do
        delete api_like_path(article_id: article.id, format: :json)
        expect(response).to have_http_status(401)
      end
    end
  end
end
