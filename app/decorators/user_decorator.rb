# frozen_string_literal: true

module UserDecorator

  # アバター画像があればActiveStorageのURLを、なければデフォ画像を表示
  def avatar_image_url
    if profile&.avatar&.attached?
      url_for(profile.avatar)
    else
      'default-avatar.svg'
    end
  end
end
