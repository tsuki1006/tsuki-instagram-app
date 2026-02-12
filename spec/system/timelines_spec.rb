require 'rails_helper'

RSpec.describe "Timelines", type: :system do

  describe 'Timeline' do

    let!(:user) { create(:user) }
    let(:following) { create(:user) }
    let!(:user_article) { create(:article, :with_image, user: user) }
    let!(:following_article) { create(:article, :with_image, user: following) }

    before do
      user.follow!(following)
    end

    describe 'ログイン前' do
      it 'ログインページに遷移' do
        visit timeline_path
        expect(page).to have_current_path(new_user_session_path)
      end
    end

    describe 'ログイン後' do
      before do
        sign_in user
      end

      it 'Timeline表示' do
        visit timeline_path
        expect(page).to have_current_path(timeline_path)
        expect(page).to have_css('.author_name', text: following.name)
        expect(page).to have_css('.author_name', text: user.name)
        expect(page).to have_css('.author_comment_content', text: following_article.content)
        expect(page).to have_css('.author_comment_content', text: user_article.content)
      end
    end
  end
end
