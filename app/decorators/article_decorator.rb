# frozen_string_literal: true

module ArticleDecorator

  def like_info
    return if likes.empty?

    first_like_user = likes.first.user
    count = likes.size
    if count == 1
      "#{first_like_user.name} liked this post"
    elsif count > 1
      other_count = count - 1
      "#{first_like_user.name} and #{other_count} other liked this post"
    end
  end
end
