class CommentMailer < ApplicationMailer
  def mentioned(mentioned_user, comment)
    @mentioned_user = mentioned_user
    @article = Article.find(comment.article_id)
    mail to: @mentioned_user.email , subject: '【お知らせ】メンションされました'
  end
end
