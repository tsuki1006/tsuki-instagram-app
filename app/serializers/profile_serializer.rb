# == Schema Information
#
# Table name: profiles
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_profiles_on_user_id  (user_id)
#
class ProfileSerializer < ActiveModel::Serializer

  attributes :id, :avatar_url

  # アバター画像が設定されていればActiveStorageのURL、されていなければnilを返す
  def avatar_url
    return nil unless object.avatar.attached?
    # object はシリアライズ対象のモデル（@profile）
    Rails.application.routes.url_helpers.polymorphic_path(object.avatar, only_path: true)
  end
end
