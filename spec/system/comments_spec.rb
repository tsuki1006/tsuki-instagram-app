require 'rails_helper'

RSpec.describe "Comments", type: :system do

  describe 'Comment', js: true do

    let!(:user) { create(:user) }
    let!(:article) { create(:article, :with_image, user: user) }
    let!(:comments) { create_list(:comment, 3, user: user, article: article) }

    before do
      visit article_comments_path(article_id: article.id)
    end

    it 'コメント一覧が表示される' do
      expect(page).to have_css('h2', text: Comment)
      expect(page).to have_css('.comment_name', text: user.name)
      expect(page).to have_css('.comment_content', text: comments.first.content)
      expect(page).to have_css('.comment_content', text: comments.second.content)
      expect(page).to have_css('.comment_content', text: comments.third.content)
    end

    describe 'ログイン前' do
      context 'コメント投稿' do
        it 'ログイン画面に遷移' do
          fill_in 'comment_content', with: 'Test comment'
          accept_alert('You need to sign in or sign up before continuing.') do
            find('#comment_content').send_keys :return
          end
          expect(page).to have_current_path(new_user_session_path)
        end
      end
    end

    describe 'ログイン後' do
      describe 'コメント投稿' do

        before do
          sign_in user
        end

        context '入力値が正常' do
          it 'コメントの投稿が成功' do
            fill_in 'comment_content', with: 'Test comment'
            find('#comment_content').send_keys :return
            expect(page).to have_css('.comment_content', text: 'Test comment')
          end
        end
        context 'content未記入' do
          it 'コメントの投稿が失敗' do
            accept_alert('コメントを入力してください') do
              find('#comment_content').send_keys :return
            end
          end
        end
      end
    end
  end
end
