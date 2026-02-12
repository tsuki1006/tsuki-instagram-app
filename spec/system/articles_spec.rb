require 'rails_helper'

RSpec.describe 'Articles', type: :system do

  let!(:user) { create(:user) }
  let!(:articles) { create_list(:article, 3, :with_image, user: user) }

  describe 'Article' do
    describe '記事一覧ページ' do
      before do
        visit root_path
      end

      it '記事一覧が表示される' do
        articles.each do |article|
          expect(page).to have_css('.author_comment_content', text: article.content)
          expect(page).to have_selector("img[src$='test.png']")
        end
      end

      describe '画面遷移' do
        it 'アカウントページ' do
          first('.article').click_link 'Avatar'
          expect(page).to have_css('.user_name', text: user.name)
        end
        it 'コメントページ' do
          first('.article').click_on 'Comment'
          expect(page).to have_css('h2', text: 'Comment')
        end
      end

      describe 'いいね' do
        describe 'ログイン前' do
          it 'すべてのハートが非アクティブ' do
            all('.inactive-heart').each do |object|
              expect(object.visible?).to eq(true)
            end
          end
          it 'いいねするとログイン画面に遷移', js: true do
            within first('.article') do
              accept_alert do
                find('.inactive-heart').click
              end
            end
            expect(current_path).to eq new_user_session_path
          end
        end

        describe 'ログイン後' do
          before do
            sign_in user
            articles.first.likes.create!(user_id: user.id)
            visit current_path
          end

          it 'いいね状況が反映', js: true do
            expect(all('.active-heart').count).to eq(1)
            expect(all('.inactive-heart').count).to eq(2)
          end

          it 'ハートをクリックでいいねできる', js: true do
            first('.inactive-heart').click
            expect(all('.active-heart').count).to eq(2)
            expect(all('.inactive-heart').count).to eq(1)
          end
        end
      end
    end

    describe '記事投稿ページ' do

      describe '記事一覧ページからの画面遷移' do
        before do
          visit root_path
        end

        context 'ログイン前' do
          it 'ログイン画面に遷移' do
            click_on 'Create new article'
            expect(page).to have_current_path(new_user_session_path)
          end
        end
        context 'ログイン後' do
          before do
            sign_in user
          end
          it '画面遷移成功' do
            click_on 'Create new article'
            expect(page).to have_current_path(new_article_path)
          end
        end
      end

      describe '新規記事作成' do
        describe 'ログイン後' do
          before do
            sign_in user
            visit new_article_path
          end

          context 'フォームの入力値が正常' do
            it '記事の新規作成が成功' do
              fill_in 'article_content', with: 'Test content'
              page.attach_file('app/assets/images/test.png') do
                page.find('#label_article_images').click
              end
              click_on 'Post'
              expect(page).to have_current_path(articles_path)
              expect(page).to have_content '投稿しました'
              expect(page).to have_content 'Test content'
            end
          end
          context 'content未記入' do
            it '記事の新規作成が失敗' do
              page.attach_file('app/assets/images/test.png') do
                page.find('#label_article_images').click
              end
              click_on 'Post'
              expect(page).to have_content "Content can't be blank"
            end
          end
          context '画像未登録' do
            it '記事の新規作成が失敗' do
              fill_in 'article_content', with: 'Test content'
              click_on 'Post'
              expect(page).to have_content "Images can't be blank"
            end
          end
        end
      end
    end
  end
end
