class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def help_post
  end

  def help_signup
  end

  def about
  end

  def contact
  end

  def privacy_policy
  end
end
