require 'rails_helper'

RSpec.describe User, type: :model do

  context 'すべての値が正常に入力されているとき' do
    let!(:user) { build(:user) }

    it 'アカウントを保存できる' do
      expect(user).to be_valid
    end
  end

  context 'nameが未入力の時' do
    let!(:user) { build(:user, name: '') }

    before do
      user.save
    end

    it 'アカウントが保存できない' do
      expect(user.errors.of_kind?(:name, :blank)).to be_truthy
    end
  end

  context 'nameが重複しているとき' do
    let!(:user) { create(:user) }
    let(:user_same_name) { build(:user, name: user.name) }

    before do
      user_same_name.save
    end

    it 'アカウントが保存できない' do
      expect(user_same_name.errors.of_kind?(:name, :taken)).to be_truthy
    end
  end

  context 'nameの文字数が20を超えているとき' do
    let!(:user) { build(:user, name: Faker::Lorem.characters(number: 21)) }

    before do
      user.save
    end

    it 'アカウントが保存できない' do
      expect(user.errors.of_kind?(:name, :too_long)).to be_truthy
    end
  end

  context 'emailが未入力のとき' do
    let!(:user) { build(:user, email: '') }

    before do
      user.save
    end

    it 'アカウントが保存できない' do
      expect(user.errors.of_kind?(:email, :blank)).to be_truthy
    end
  end

  context 'emailが正規表現から外れているとき' do
    let!(:user) { build(:user, email: Faker::Lorem.characters(number: 16)) }

    before do
      user.save
    end

    it 'アカウントが保存できない' do
      expect(user.errors.of_kind?(:email, :invalid)).to be_truthy
    end
  end

  context 'emailが重複しているとき' do
    let!(:user) { create(:user) }
    let(:user_same_email) { build(:user, email: user.email) }

    before do
      user_same_email.save
    end

    it 'アカウントが保存できない' do
      expect(user_same_email.errors.of_kind?(:email, :taken)).to be_truthy
    end
  end
end
