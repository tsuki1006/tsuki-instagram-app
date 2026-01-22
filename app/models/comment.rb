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
class Comment < ApplicationRecord
  validates :content, presence: true

  belongs_to :user
  belongs_to :article

  after_create :send_email

  private
  def send_email
    user_name_pattern = /@([^@\s、。！？（）「」『』.,()!?:;]+)/
    mentioned_users = self.content.scan(user_name_pattern).flatten

    mentioned_users.each do |user|
      mentioned_user = User.find_by(name: user)
      if mentioned_user.present?
        CommentMailer.mentioned(mentioned_user, self).deliver_later
      end
    end
  end
end
