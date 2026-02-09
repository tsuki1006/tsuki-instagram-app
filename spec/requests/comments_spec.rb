require 'rails_helper'

RSpec.describe 'Comments', type: :request do

  let!(:user) { create(:user) }
  let!(:article) { create(:article, :with_image, user: user) }
  let!(:comments) { create_list(:comment, 3, user: user, article: article) }

  describe 'GET /comments' do

    it '200 Status' do
      get article_comments_path(article_id: article.id)
      expect(response).to have_http_status(200)
    end

    context 'jsonのリクエストを送った場合' do
      it '200 Status コメントが返される' do
        get article_comments_path(article_id: article.id), as: :json
        expect(response).to have_http_status(200)

        body = JSON.parse(response.body)
        expect(body.length).to eq 3
        expect(body[0]['content']).to eq comments.first.content
        expect(body[1]['content']).to eq comments.second.content
        expect(body[2]['content']).to eq comments.third.content
      end
    end
  end

  describe 'POST /comments' do
    context 'ログインしている場合' do
      before do
        sign_in user
      end

      it '200 Status コメントが作成される' do
        comment_params = attributes_for(:comment).merge(user_id: user.id)

        post article_comments_path(article_id: article.id), params: { comment: comment_params }
        expect(response).to have_http_status(200)
        expect(Comment.last.content).to eq(comment_params[:content])

        body = JSON.parse(response.body)
        expect(body['content']).to eq(comment_params[:content])
      end
    end

    context 'ログインしていない場合' do
      it '401 Status' do
        comment_params = attributes_for(:comment).merge(user_id: user.id)

        post article_comments_path(article_id: article.id, format: :json), params: { comment: comment_params }
        expect(response).to have_http_status(401)
      end
    end

  end
end
