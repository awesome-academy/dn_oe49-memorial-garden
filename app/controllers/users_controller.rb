class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(edit update)
  before_action ->{load :user, :id}, only: %i(edit show update)
  before_action ->{correct_user @user}, only: %i(edit update)

  def show; end

  def new
    @user = User.new
  end

  def create
    build_user_through_params
    if @user.save
      log_in @user
      flash[:success] = t("flash.create.successed")
      redirect_to @user
    else
      flash.now[:danger] = t("flash.create.failed")
      respond_to do |format|
        format.html{render :new}
        format.js{render :error}
      end
    end
  end

  def edit; end

  def update
    avatar = params[:user][:avatar]
    @user.avatar.attach(avatar) if avatar.present?
    if @user.update(user_params)
      flash[:success] = t("flash.update.successed")
      redirect_to @user
    else
      flash.now[:danger] = t("flash.update.failed")
      respond_to do |format|
        format.html{render :edit}
        format.js{render :error}
      end
    end
  end

  private

  def build_user_through_params
    @user = User.new(user_params)
    avatar = params[:user][:avatar]
    @user.avatar.attach(avatar) if avatar.present?
  end

  def user_params
    params.require(:user).permit(User::ATR_PERMIT)
  end
end
