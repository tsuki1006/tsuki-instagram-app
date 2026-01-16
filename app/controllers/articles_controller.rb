class ArticlesController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create ]

  def index
  end

  def new
    @article = current_user.articles.build
  end

  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      redirect_to articles_path, notice: '投稿しました'
    else
      flash.now[:error] = '投稿に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  private
  def article_params
    params.require(:article ).permit( :content, images: [] )
  end
end
