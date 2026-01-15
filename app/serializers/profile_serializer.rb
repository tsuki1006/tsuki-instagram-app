class ProfileSerializer < ActiveModel::Serializer

  attributes :id, :avatar_url

  # アバター画像が設定されていればActiveStorageのURL、されていなければnilを返す
  def avatar_url
    return nil unless object.avatar.attached?
    # object はシリアライズ対象のモデル（@profile）
    Rails.application.routes.url_helpers.polymorphic_path(object.avatar, only_path: true)
  end
end
