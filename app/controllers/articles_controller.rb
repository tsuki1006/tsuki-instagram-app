class ArticlesController < ApplicationController
  before_action :authenticate_user!, only: [ :new ]

  def index
  end

  def new
    @article = current_user.articles.build
  end
end
