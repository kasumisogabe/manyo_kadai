class Admin::UsersController < ApplicationController
  before_action :set_user, only: %i[ edit update show destroy ]
  before_action :require_admin

  def index
    @users = User.all.includes(:tasks)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_user_url(@user), notice: "ユーザー登録が完了しました"
    else
      render :new
    end
  end

  def edit
  end

  def show
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_url(@user), notice: "ユーザー情報を更新しました"
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to admin_users_path,notice: "削除しました"
    else
      render :edit
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password,
                              :password_confirmation, :admin)
  end

  def require_admin
    unless current_user.admin?
      redirect_to root_path, notice: "管理者以外はアクセスできません"
    end
  end
end
