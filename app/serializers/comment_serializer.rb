# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  article_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_comments_on_article_id  (article_id)
#  index_comments_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (user_id => users.id)
#
class CommentSerializer < ActiveModel::Serializer

  attributes :content, :user_name, :avatar_url

  # ユーザー名
  def user_name
    user = object.user
    user.name
  end

  # アバター画像が設定されていればActiveStorageのURL、されていなければデフォルト画像のURLを返す
  def avatar_url
    object.user.avatar_url_for_api
  end

end
