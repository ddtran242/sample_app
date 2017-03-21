class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def index
    @user = User.find_by id: params[:user_id]
    unless @user
      flash[:danger] = t "not_found_user"
      redirect_to :back
    end
    @title = params[:type].capitalize
    @users = @user.send(params[:type]).paginate page: params[:page]
  end

  def create
    @user = User.find_by id: params[:followed_id]
    if @user
      current_user.follow @user
      @supports = Supports::User.new current_user, @user
      respond_to do |format|
        format.html {redirect_to @user}
        format.js
      end
    else
      flash[:danger] = t "not_found_user"
      redirect_to root_url
    end

  end

  def destroy
    @user = Relationship.find_by(id: params[:id]).followed
    current_user.unfollow @user
    @supports = Supports::User.new current_user, @user
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end
end
