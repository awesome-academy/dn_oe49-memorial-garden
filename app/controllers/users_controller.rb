class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(edit update)
  before_action :load_user, only: %i(edit show update)
  before_action :correct_user, only: %i(edit update)

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.avatar.attach(params[:user][:avatar])
    if @user.save
      log_in @user
      flash[:success] = t("flash.signup.successed")
      redirect_to @user
    else
      flash.now[:danger] = t("flash.signup.failed")
      render :new
    end
  end

  def edit; end

  def update
    @user.avatar.attach(params[:user][:avatar])
    if @user.update(user_params)
      flash[:success] = t("flash.update.successed")
      redirect_to @user
    else
      flash.now[:danger] = t("flash.update.failed")
      render :edit
    end
  end

  private

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t("flash.login.warning_user")
    redirect_to login_url
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t("flash.show.failed")
    redirect_to new_user_path
  end

  def correct_user
    return if current_user?(@user)

    flash[:danger] = t("flash.edit.wrong_user")
    redirect_to(root_url)
  end

  def user_params
    params.require(:user).permit(User::ATR_PERMIT)
  end
end
