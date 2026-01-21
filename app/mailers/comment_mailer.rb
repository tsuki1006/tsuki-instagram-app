class CommentMailer < ApplicationMailer
  def mentioned(user, comment)
    @user = user
    @article = Article.find(comment.article_id)
    mail to: user.email , subject: '【お知らせ】メンションされました'
  end
end