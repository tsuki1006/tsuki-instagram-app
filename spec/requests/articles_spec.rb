require 'rails_helper'

RSpec.describe 'Articles', type: :request do

  let!(:user) { create(:user) }
  let!(:articles) { create_list(:article, 3, :with_image, user: user) }

  describe 'GET /articles' do
    it '200ステータスが返ってくる' do
      get articles_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /articles' do
    context 'ログインしている場合' do
      before do
        sign_in user
      end

      it '記事が保存される' do
        image = fixture_file_upload('app/assets/images/test.png', 'image/png')
        article_params = attributes_for(:article).merge(images: [image])

        post articles_path, params: { article: article_params }
        expect(response).to have_http_status(302)

        expect(Article.last.content).to eq(article_params[:content])
        expect(Article.last.images.first.blob.filename).to eq('test.png')
      end
    end

    context 'ログインしていない場合' do
      it 'ログイン画面に遷移する' do
        image = fixture_file_upload('app/assets/images/test.png', 'image/png')
        article_params = attributes_for(:article).merge(images: [image])

        post articles_path, params: { article: article_params }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
