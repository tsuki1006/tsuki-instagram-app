require 'rails_helper'

RSpec.describe Comment, type: :model do

  let!(:user) { create(:user) }
  let!(:article) { build(:article, :with_image, user: user) }

  context 'すべての値が正常に入力されているとき' do
    let!(:comment) { build(:comment, user: user, article: article) }

    it 'コメントを保存できる' do
      expect(comment).to be_valid
    end
  end

  context 'contentが未入力の時' do
    let!(:comment) { build(:comment, user: user, article: article, content: '') }

    before do
      comment.save
    end

    it 'コメントを保存できない' do
      expect(comment.errors.of_kind?(:content, :blank)).to be_truthy
    end
  end

  context 'contentの文字数が200を超えているとき' do
    let!(:comment) { build(:comment, user: user, article: article, content: Faker::Lorem.characters(number: 201)) }

    before do
      comment.save
    end

    it 'コメントを保存できない' do
      expect(comment.errors.of_kind?(:content, :too_long)).to be_truthy
    end
  end

end
