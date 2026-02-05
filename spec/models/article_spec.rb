require 'rails_helper'

RSpec.describe Article, type: :model do

  let!(:user) { create(:user) }

  context 'すべての値が正常に入力されているとき' do
    let!(:article) { build(:article, :with_image, user: user) }

    it '記事を保存できる' do
      expect(article).to be_valid
    end
  end

  context 'contentが未入力の時' do
    let!(:article) { build(:article, :with_image, content: '') }

    before do
      article.save
    end

    it '記事を保存できない' do
      expect(article.errors.of_kind?(:content, :blank)).to be_truthy
    end
  end

  context 'contentの文字数が300を超えているとき' do
    let!(:article) { build(:article, :with_image, content: Faker::Lorem.characters(number: 301)) }

    before do
      article.save
    end

    it '記事を保存できない' do
      expect(article.errors.of_kind?(:content, :too_long)).to be_truthy
    end
  end

  context 'imagesが未入力の時' do
    let!(:article) { build(:article) }

    before do
      article.save
    end

    it '記事を保存できない' do
      expect(article.errors.of_kind?(:images, :blank)).to be_truthy
    end
  end
end
