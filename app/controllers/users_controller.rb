class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t("flash.show.failed")
    redirect_to new_user_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    log_in @user
    if @user.save
      flash[:success] = t("flash.signup.successed")
      redirect_to @user
    else
      flash.now[:danger] = t("flash.signup.failed")
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(User::ATR_PERMIT)
  end
end
