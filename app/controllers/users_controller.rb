class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :friends]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "ようこそ、Gatebookへ！"
      log_in @user
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "プロフィールを更新しました。"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "アカウントを削除しました。"
    redirect_to users_url
  end

  def friends
    @title = "友達"
    @user = User.find(params[:id])
    @users = @user.friends.paginate(page: params[:page])
    render 'show_friend'
  end

  def likes
    @title = "いいね!"
    @user = User.find(params[:id])
    @post = @user.posts.build
    @posts = @user.liked_posts.paginate(page: params[:page])
    render 'show_liked'
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
    
     def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
