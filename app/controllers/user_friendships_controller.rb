class UserFriendshipsController < ApplicationController
  before_action :logged_in_user
  
  def create
    @user = User.find(params[:user_friendship][:friend_id])
    current_user.add_friend!(@user)
    flash[:success] = "友達になりました。"
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = UserFriendship.find(params[:id]).friend
    current_user.unfriend!(@user)
    flash[:success] = "友達を削除しました。"
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
