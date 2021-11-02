class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(edit update)
  before_action ->{load :user, :id}, only: %i(edit show update)
  before_action ->{correct_user @user}, only: %i(edit update)

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

  def user_params
    params.require(:user).permit(User::ATR_PERMIT)
  end
end
