class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  before_action :set_user, only: %i[ show edit update destroy ]

  def index
    @users = User.all
  end

  def new
    redirect_to user_path(current_user.id) if logged_in?
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user.id)
    else
      render :new
    end
  end

    def show
      if current_user == User.find(params[:id])
        @user = User.find(params[:id])
      else
        redirect_to tasks_path, notice: "権限がありません"
      end
    end
  
    def edit
      if @user == current_user
        render "edit"
      else
        redirect_to users_path
      end
    end
  
    def update
      if @user.update(user_params)
        redirect_to user_path, notice: "プロフィールを編集しました！"
      else
        flash.now[:danger] = "プロフィールを更新できませんでした"
        render :edit
      end
    end

    def destroy
      @user.destroy
      redirect_to users_url, notice: "ユーザーを削除しました"
    end
  
    private

    def set_user
      @user = User.find(params[:id])
    end
  
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                  :password_confirmation,)
    end
end