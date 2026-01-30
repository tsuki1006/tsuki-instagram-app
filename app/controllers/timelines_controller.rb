class TimelinesController < ApplicationController
  before_action :authenticate_user!

  def show
    # フォローしているユーザの投稿
    followings_ids = current_user.followings.pluck(:id)
    followings_articles = Article.where(user_id: followings_ids)

    # 24時間以内に作成された投稿の中で「いいね」が多い投稿を5つ
    recent_article = Article.where('articles.created_at >= ?', 24.hours.ago)
    top5_articles = recent_article.left_joins(:likes).group(:id).order('COUNT(likes.id) DESC').limit(5)

    # 記事のidを取得
    ids = followings_articles.pluck(:id) + top5_articles.pluck(:id)

    # 重複を消して、新着順に記事を取得
    @timeline_articles = Article.where(id: ids.uniq).order(created_at: :desc)
  end
end
